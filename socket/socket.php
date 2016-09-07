<?php

	// ZZZz


	function _echo($id, $message) {
		$message = $id . strftime(' %H:%M:%S ', time()) . $message;
		echo $message;
		$directory = defined('LOGGER') ? constant('LOGGER') : '';
		$log_prefix = defined('LOG_PREFIX') ? constant('LOG_PREFIX') : __FILE__;
		file_put_contents(strftime($directory . $log_prefix . '_%Y%m%d.log', time()), $message, FILE_APPEND);
	}

	function fsize($file) {
		$pos = 0;
		$size = 1073741824;
		$fp = fopen($file, 'rb');
		fseek($fp, 0, SEEK_SET);
		while ($size > 1) {
			fseek($fp, $size, SEEK_CUR);
			if (fgetc($fp) === false) {
				fseek($fp, -$size, SEEK_CUR);
				$size = (int) ($size / 2);
			} else {
				fseek($fp, -1, SEEK_CUR);
				$pos += $size;
			}
		}

		while (fgetc($fp) !== false) {
			$pos++;
		}
		fclose($fp);
		return $pos;
	}

	// 受到PHP性能限制（包括pthread自身限制以及代码加密，锁等待等问题）
	// 经过测试，这个休眠时间几乎是必须的
	// 要完美解决这个问题，需要使用golang
	define('USLEEP_TIME', 10000);
	function recv_data($socket, $length, $max_time) {
		$time = microtime(true);
		$recv_length = 0;
		$data = '';
		$close_flag = false;
		while (microtime(true) - $time <= $max_time && $recv_length < $length) {
			if (!is_resource($socket) || $close_flag) {
				break;
			}
			$recv_length_this = socket_recv($socket, $temp_data, $length - $recv_length, MSG_DONTWAIT);
			$recv_length += $recv_length_this;
			$data .= $temp_data;
			if ($recv_length_this === 0) {
				$close_flag = true;
			}
			usleep(USLEEP_TIME);
		}
		return array($recv_length, $data);
	}

	function data_get($sem, $shm, $index) {
		$data_array = array();
		if (sem_acquire($sem, false)) {
			$data_array = shm_get_var($shm, $index);
			sem_release($sem);
		}
		return $data_array;
	}
	function data_set($sem, $shm, $index, $data) {
		if (sem_acquire($sem, false)) {
			$data_array = array();
			if (shm_has_var($shm, $index)) {
				$data_array = shm_get_var($shm, $index);
			}
			shm_put_var($shm, $index, $data);
			sem_release($sem);
		}
		return $data_array;
	}
	function data_merge($sem, $shm, $index, $array) {
		if (sem_acquire($sem, false)) {
			$data_array = shm_get_var($shm, $index);
			$keys = array_keys($array);
			$values = array_values($array);
			for ($i = 0; $i < count($keys); $i++) {
				$data_array[$keys[$i]] = $values[$i];
			}
			shm_put_var($shm, $index, $data_array);
			sem_release($sem);
		}
		return $data_array;
	}
	function data_append($sem, $shm, $index, $array) {
		if (sem_acquire($sem, false)) {
			$data_array = shm_get_var($shm, $index);
			$data_array[] = $array;
			shm_put_var($shm, $index, $data_array);
			sem_release($sem);
		}
		return $data_array;
	}


	/**
	 * Socket IO基类<br/>
	 */
	class SocketIO extends Thread {
		function __construct($array) {
			$this->id = $array[0];
			$this->sem = $array[1];
			$this->shm = $array[2];
			$this->socket = $array[3];
			$this->max_connection = $array[4];
			$this->max_wait_time = $array[5];
			$this->start();
		}
		function data_get($index) {
			return data_get($this->sem, $this->shm, $index);
		}
		function data_set($index, $data) {
			return data_set($this->sem, $this->shm, $index, $data);
		}
		function data_merge($index, $array) {
			return data_merge($this->sem, $this->shm, $index, $array);
		}
		function data_append($index, $array) {
			return data_append($this->sem, $this->shm, $index, $array);
		}
	}


	/**
	 * 保存线程共享数据<br/>
	 *      $index<br/>
	 *      一般用数组（读线程写入，写线程读出，除非写线程有消息写入以通知给其他读/写线程对）<br/>
	 *      <br/>
	 * 保存客户端连接信息（READ, WRITE，IP，PORT，START_TIME）<br/>
	 *      $max_connection + $index<br/>
	 *      读写线程对标识<br/>
	 *			READ： 0 未开启 1 正在运行 2 已退出<br/>
	 *			WRITE： 0 未开启 1 正在运行 2 已退出<br/>
	 *		<br/>
	 * 主线程运行标识<br/>
	 * 		2 * $max_connection<br/>
	 * 		false 通知所有线程退出<br/>
	 */
	function connect($ip, $port, $read_class, $write_class, $max_connection = 10, $max_wait_time = 5) {
		$directory = defined('LOGGER') ? constant('LOGGER') : '.';
		if (!file_exists($directory)) {
			mkdir($directory, 0777, true);
		}
		$log_prefix = defined('LOG_PREFIX') ? constant('LOG_PREFIX') : __FILE__;
		file_put_contents($directory . $log_prefix . '.pid', getmypid());

		set_time_limit(0);
		ob_implicit_flush();
		$key = ftok(tempnam(time(), rand(0, 10000)), 's');
		$sem = sem_get($key);
		$shm = shm_attach($key, $max_connection * 1000000);
		for ($i = 0; $i < $max_connection; $i++) {
			data_set($sem, $shm, $i, array());
			data_set($sem, $shm, $max_connection + $i, array('READ' => 0, 'WRITE' => 0));
		}
		data_set($sem, $shm, 2 * $max_connection, true);
		$sockets = array();
		$reads = array();
		$writes = array();
		if ($ip === null) {
			$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
			socket_set_option($socket, SOL_SOCKET, SO_REUSEADDR, 1);
			socket_set_nonblock($socket);
			$ip = '0.0.0.0';
			if (!@socket_bind($socket, $ip, $port)) {
				die('can not bind "' . $ip . ':' . $port . '"' . PHP_EOL);
			}
			socket_listen($socket);
			_echo('=', 'waiting for clients ...' . PHP_EOL);
			$array = array(null, $sem, $shm, null, $max_connection, $max_wait_time);
			while (shm_get_var($array[2], 2 * $max_connection)) {
				$s = socket_accept($socket);
				$index = -1;
				for ($i = 0; $i < $max_connection; $i++) {
					$data_array = shm_get_var($array[2], $max_connection + $i);
					if (in_array($data_array['READ'], array(0, 3)) && in_array($data_array['WRITE'], array(0, 3))) {
						if ($index == -1) {
							@socket_shutdown($sockets[$i], 2);
							@socket_close($sockets[$i]);
							$index = $i;
							break;
						}
					}
				}
				if (is_resource($s)) {
					if ($index == -1) {
						@socket_shutdown($s, 2);
						socket_close($s);
						_echo('=', $address . ':' . $port . ' has been disconnected (queue is full)' . PHP_EOL);
					} else {
						socket_set_nonblock($s);
						socket_getpeername($s, $address, $port);
						$sockets[$index] = $s;
						_echo('=', $address . ':' . $port . ' has connected' . PHP_EOL);
						$array[0] = $index;
						$array[3] = $s;
						data_set($array[1], $array[2], $array[4] + $array[0], array('READ' => 1, 'WRITE' => 1, 'IP' => $address, 'PORT' => $port, 'START_TIME' => time()));
						$reads[$index] = new $read_class($array);
						$writes[$index] = new $write_class($array);
					}
				}
				usleep($max_connection * USLEEP_TIME);
			}
			_echo('=', 'server is exiting ...' . PHP_EOL);
		} else {
			$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
			socket_set_nonblock($socket);
			_echo('=', 'waiting for server ...' . PHP_EOL);
			while (!@socket_connect($socket, $ip, $port)) {
				sleep(1);
			}
			_echo('=', 'connected to ' . $ip . ':' . $port . PHP_EOL);
			data_set($sem, $shm, 1, array('READ' => 1, 'WRITE' => 1, 'IP' => $ip, 'PORT' => $port, 'START_TIME' => time()));
			$array = array(0, $sem, $shm, $socket, 1, $max_wait_time);
			$read = new $read_class($array);
			$write = new $write_class($array);
			$read->join();
			$write->join();
			_echo('=', 'client is exiting ...' . PHP_EOL);
		}
		@socket_shutdown($socket, 2);
		socket_close($socket);
		sem_remove($sem);
		shm_remove($shm);
	}
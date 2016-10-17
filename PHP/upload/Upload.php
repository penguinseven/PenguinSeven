<?php

namespace ext;

/**
 * php 文件上传类，涉及到分片上传时，客户端需配合webuploader使用
 * 结果状态['status'] 0 => 失败.
 * 1 => 成功
 * 错误代码 ['ecode'] 103 => 非法请求 102 => 请求中参数不够 103 =》文件后缀名不合法
 * 200 => 成功(没有错误)
 * 501 => 打开临时文件失败 502=> 打开目的文件失败 503=> 不能读取输入表单文件上 504=> 不能读取输入文件流(二进制)
 * 额外信息 ['message']
 *
 * @todo debug
 * @author 刘宇彬
 *        
 */
class Upload {
	
	/**
	 * 保存路径
	 *
	 * @access private
	 */
	private $save_dir;
	
	/**
	 * 最终保存的文件名,不包括后缀,后缀由上传的文件决定
	 */
	private $save_name;
	
	/**
	 * 临时路径
	 *
	 * @access private
	 */
	private $tmp_dir;
	
	/**
	 * 临时文件名前缀
	 *
	 * @access private
	 */
	private $tmp_path;
	
	/**
	 *
	 * @access private
	 *         日志信息
	 */
	private $loginfo = array ();
	
	/**
	 * 允许的文件后缀
	 *
	 * @access private
	 */
	private $exts;
	
	/**
	 * 分片过期时间
	 */
	private $max_age = 600;
	
	/**
	 * 客户端实际上传的文件名
	 */
	private $upload_file_name;
	
	/**
	 * 上传方式 0=> 传统表单上传 2=> 二进制流上传
	 */
	private $upload_type;
	
	/**
	 * 上传表单域的名称
	 */
	private $field_name;
	
	/*
	 * token保证上传的唯一性
	 */
	private $token;
	
	/**
	 * 构造函数，完成上传类赋值
	 */
	public function __construct($target_dir = '', $tmp_dir = '', $field_name = '') {
		$this->save_dir = $target_dir;
		$this->tmp_dir = $target_dir . '/tmp';
		$this->field_name = $field_name == '' ? 'file' : $field_name;
		$this->max_age = 10800;
	}
	public function setopt($name, $value) {
		$this->$name = $value;
		return $this;
	}
	
	/**
	 * 初始化上传类
	 */
	public function initialize() {
		header ( "Expires: Mon, 26 Jul 1997 05:00:00 GMT" );
		header ( "Last-Modified: " . gmdate ( "D, d M Y H:i:s" ) . " GMT" );
		header ( "Cache-Control: no-store, no-cache, must-revalidate" );
		header ( "Cache-Control: post-check=0, pre-check=0", false );
		header ( "Pragma: no-cache" );
		if (isset ( $_REQUEST ['lastModifiedDate'] )) {
			$this->token = $_REQUEST ['lastModifiedDate'];
		}
		$this->log ( '0', '0', 'none' );
	}
	
	/**
	 * 检查本次上传是否合法
	 * return bool
	 */
	private function validate() {
		// 检查上传表单域
		if (! empty ( $_FILES [$this->field_name] )) {
			$this->upload_file_name = $_FILES [$this->field_name] ['name'];
			$this->upload_type = 1;
		} else {
			// 二进制方式上传，必须有$this->field_name 指定的URL参数
			if (isset ( $_REQUEST [$this->field_name] )) {
				$this->upload_file_name = $_REQUEST [$this->field_name];
			} else {
				$this->log ( '0', '102', 'not enough params' );
				return false;
			}
			$this->upload_type = 2;
		}
		
		if (! count ( $this->exts ))
			return true;
		$ext = pathinfo ( $this->upload_file_name, PATHINFO_EXTENSION );
		if (in_array ( $ext, $this->etxs ))
			return true;
		
		$this->log ( '0', '501', 'extension invaild' );
		return flase;
	}
	
	/**
	 * 触发上传动作
	 *
	 * @return mixed
	 */
	public function upload() {
		// 10 分钟执行时间
		@set_time_limit ( 600 );
		$this->initialize ();
		
		// 验证失败时返回错误信息
		if (! $this->validate ()) {
			return $this->loginfo;
		}
		$this->del_expire ();
		
		// 分片上传失败时返回错误信息
		if (! $this->upload_chunk ())
			return $this->loginfo;
			// 合并所有分片
		$this->megre ();
		return $this->loginfo;
	}
	
	/**
	 * 处理过期的分片
	 */
	public function del_expire() {
		$dir = @opendir ( $this->tmp_dir );
		if (! $dir)
			return;
		while ( $file = readdir ( $dir ) !== false ) {
			$del_path = $this->tmp_dir . '/' . $file;
			
			if (file_exists ( $del_path ) && fileatime ( $del_path ) < time () - $this->max_age) {
				@unlink ( $del_path );
			}
		}
	}
	
	/**
	 * 处理上传分片
	 *
	 * @return bool
	 */
	public function upload_chunk() {
		if (! is_dir ( $this->tmp_dir ))
			@mkdir ( $this->tmp_dir );
		$this->tmp_path = $this->tmp_dir . '/' . md5 ( $this->upload_file_name . $this->token );
		$chunk = isset ( $_REQUEST ["chunk"] ) ? intval ( $_REQUEST ["chunk"] ) : 0;
		// 打开临时存储文件
		if (! $out = @fopen ( $this->tmp_path . "_{$chunk}.tmppart", 'wb' )) {
			// @todo
			$this->log ( '0', '501', 'can not open tmp file' );
			return false;
		}
		// 尝试打开文件输入流
		if (! empty ( $_FILES )) {
			if (! $in = @fopen ( $_FILES [$this->field_name] ["tmp_name"], "rb" )) {
				$this->log ( '0', '503', "can't not open input file" );
				return false;
			}
		} else {
			// 直接读取二进制流
			if (! $in = fopen ( 'php://input', 'rb' )) {
				$this->log ( '0', '504', "can't not open input stream" );
				return false;
			}
		}
		while ( $buff = fread ( $in, 4096 ) ) {
			fwrite ( $out, $buff );
		}
		@fclose ( $in );
		@fclose ( $out );
		@rename ( $this->tmp_path . "_{$chunk}.tmppart", $this->tmp_path . "_{$chunk}.part" );
		return true;
	}
	
	/**
	 * 检查是否所有分片上传完成
	 *
	 * @return bool
	 */
	public function check_uploaded() {
		$chunks = isset ( $_REQUEST ["chunks"] ) ? intval ( $_REQUEST ["chunks"] ) : 1;
		for($i = 0; $i < $chunks; $i ++) {
			if (! file_exists ( $this->tmp_path . "_{$i}.part" )) {
				return false;
			}
		}
		return true;
	}
	
	/**
	 * 　合并分片
	 *
	 * @return bool
	 */
	public function megre() {
		// j检查所有分片是否上传完成
		if ($this->check_uploaded () !== true) {
			return false;
		}
		$this->save_name = $this->save_name . "." . pathinfo ( $this->upload_file_name, PATHINFO_EXTENSION );
		$save_path = $this->save_dir . '/' . $this->save_name;
		
		if (! $out = @fopen ( $save_path, 'wb' )) {
			$this->log ( '0', '502', "can't not open output file" );
			return false;
		}
		
		if (flock ( $out, LOCK_EX )) {
			$chunks = isset ( $_REQUEST ["chunks"] ) ? intval ( $_REQUEST ["chunks"] ) : 1;
			// 遍历每个分片
			for($i = 0; $i < $chunks; $i ++) {
				if (! $in = @fopen ( $this->tmp_path . "_{$i}.part", 'rb' )) {
					break;
				}
				while ( $buff = fread ( $in, 4096 ) ) {
					fwrite ( $out, $buff );
				}
				@fclose ( $in );
				@unlink ( $this->tmp_path . "_{$i}.part" ); // 删除已合并分片
			}
			flock ( $out, LOCK_UN );
		}
		
		@fclose ( $out );
		$this->loginfo ['FILE_PATH'] = $save_path; // 文件最终路径
		$this->log ( '1', '200', 'ok' );
		return true;
	}
	
	/**
	 * log
	 */
	private function log($status, $ecode, $message = '') {
		$this->loginfo ['status'] = $status;
		$this->loginfo ['ecode'] = $ecode;
		$this->loginfo ['message'] = $message;
	}
}


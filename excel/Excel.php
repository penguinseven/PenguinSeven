<?php
    /**
     *  Excel 类封装
     * Date: 16-5-19
     * Time: 下午3:27
     */

    namespace b\Model;


    class Excel extends Base{

        private $classPath = '../Library/ext/PHPExcel/PHPExcel.php'; // PHPExcel 类路径
        private $obj = null; // PHPExcle 对象保存
        private $writer = null; //  对象保存
        private $error = null;
        private $default = array(
            'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
        );

        /**
         * Excel constructor. 引入类文件，创建资源句柄
         */
        public function __construct(){
            parent::__construct();
            require_once($this->classPath);
            require_once ("../Library/ext/PHPExcel/PHPExcel/Worksheet/Drawing.php");
            require_once ("../Library/ext/PHPExcel/PHPExcel/IOFactory.php");

            $this->obj = new \PHPExcel();
        }

        /**
         * 数据导入操作
         * @param $filePath     string      文件路径
         * @param $sheetName    array       sheet名称     ex： array('用户签到'，‘Sheet1’)
         * @param $title        array       数据格式      ex： array（‘title’=> '标题'，‘password’=>'密码'）
         * @param $start        int         开始行数      ex : 1 (从第1行开始, 必须大于0)
         * @return array
         */
        public function import($filePath, $sheetName, $title, $start){

            $fileType=\PHPExcel_IOFactory::identify($filePath);//自动获取文件的类型提供给phpexcel用
            $objReader=\PHPExcel_IOFactory::createReader($fileType);//获取文件读取操作对象
            $objReader->setLoadSheetsOnly($sheetName);//只加载指定的sheet
            $objPHPExcel=$objReader->load($filePath);//加载文件
            $sheetCount=$objPHPExcel->getSheetCount();//获取excel文件里有多少个sheet


            // 重新拼接数据
            $list = array();
            $num = array_keys($title);
            $data = array();
            $start--;

            for($i=0;$i<$sheetCount;$i++){
                //读取每个sheet里的数据 全部放入到数组中
                $data = array_merge($objPHPExcel->getSheet($i)->toArray(), $data) ;
            }

            foreach ($data as $k => $v) {
                if($k < $start){
                    continue;
                }

                foreach ($v as $key => $value) {
                    if($key < count($num)){
                        $list[$k][$num[$key]] = $value;
                    }else{
                        break;
                    }
                }
            }
            return $list;
        }

        /**
         *  数据导出操作
         * @param array $title      标题行
         * @param array $data       数据
         * @param string $name      sheet标题
         * @return array
         */
        public function export($title, $data, $name = ''){
            
            // 获取当前sheet，生成一个sheet对象
            $sheet = $this->obj->getActiveSheet();
            $total =count($title);

            // 设置sheet标题
            if(!empty($name)){
                $sheet->setTitle($name);
            }

            // 设置样式
            $sheet->getDefaultStyle()->getAlignment()->setVertical(\PHPExcel_Style_Alignment::VERTICAL_CENTER)->setHorizontal(\PHPExcel_Style_Alignment::HORIZONTAL_CENTER);//设置excel文件默认水平垂直方向居中
            $sheet->getDefaultStyle()->getFont()->setSize($this->other['excel_default_font_size'])->setName($this->other['excel_default_font_family']);//设置默认字体大小和格式
            $sheet->getStyle("A1:". $this->default[$total -1] . '1')->getFont()->setSize(18)->setBold(true)->getColor()->setRGB($this->other['excel_first_row_color']);//设置第一行字体大小和加粗

            $sheet->getStyle( "A1:". $this->default[$total -1] . '1')->getFill()->setFillType(\PHPExcel_Style_Fill::FILL_SOLID);
            $sheet->getStyle( "A1:". $this->default[$total -1] . '1')->getFill()->getStartColor()->setRGB($this->other['excel_first_row_background']); //设置背景色

            $sheet->getDefaultRowDimension()->setRowHeight($this->other['excel_default_row_height']);//设置默认行高


            // 设置标题行
            if($total > count($this->default)){
                $this->error = array ('status' => 'error', 'message' => '数据列数超出范围');
                return ;
            }

            foreach ($title as $k => $v) {
                $sheet->setCellValue($this->default[$k] . 1, $v['title']);

                if($v['width'] == 'auto'){  // 标题行 宽高
                    $sheet->getColumnDimension($this->default[$k])->setAutoSize(true);
                }else{
                    $sheet->getColumnDimension($this->default[$k])->setWidth((int)$v['width']);
                }
            }

            foreach ($data as $key => $item) {
                if(count($item) != $total){
                    $this->error = array ('status' => 'error', 'message' => '数据与标题长度不对应');
                    return ;
                    break;
                }
            }

            // 添加数据
            $res = $this->set_sheet_value($sheet, $title, $data);

            if (!empty($res)) return $res;

            $this->writer = \PHPExcel_IOFactory::createWriter($this->obj, 'Excel5');//生成excel文件

        }

        /**
         *  添加数据
         * @param $sheet  sheet 资源句柄
         * @param $title  标题行数据
         * @param $data   内容数据
         * @return array
         */
        private function set_sheet_value($sheet, $title, $data){

            $length = count($title);
            foreach($data as $k => $v){
                $len = count($v);
                $row = $k +2;
                if($len == 0) break;
                if($length != $len){
                    return array ('status' => 'error', 'message' => '第' . $row . '条数据信息不全');
                }

                $i = 0;
                foreach($v as $key => $value){
                    if (preg_match('/^\/home/i',$value)) {
                        if(is_file($value)){
                            $res = $this->save_img_value($sheet,$value,$this->default[$i] , $row);
                            if($res !== false){
                                continue;
                            }
                        }else{
                            continue;
                        }
                    }
                    $sheet->setCellValue($this->default[$i] . $row, $value);
                    $i++;
                }
            }
        }

        /**
         * 保存图片
         * @param $sheet sheet资源句柄
         * @param $path  图片路径
         * @param $pos  列数
         * @param $num  行数
         * @return bool
         */
        private function save_img_value($sheet, $path, $pos, $num) {

            if (!getimagesize($path)) {
                return false;
            }


            $objDrawing=new \PHPExcel_WorkSheet_Drawing();//获得一个图片的操作对象

            $objDrawing->setPath($path);//加载图片路径
            $objDrawing->setCoordinates($pos . $num);//设置图片插入位置的左上角坐标
            $objDrawing->setHeight($this->other['excel_default_img_size']);//设置插入图片的大小
            $objDrawing->setOffsetX($this->other['excel_default_img_set_x'])->setOffsetY($this->other['excel_default_img_set_y']);//设定单元格内偏移量
            $sheet->getRowDimension($num)->setRowHeight($this->other['excel_default_img_height']);//设置行高
            $objDrawing->setWorkSheet($sheet);//将图片插入到sheet

        }

        /**
         *  保存excel文件
         * @param $path  保存路径
         * @param $fileName 保存名称(不含后缀)
         */
        public function save_excel($path, $fileName){
            if(!is_dir($path)){
                @mkdir($path, 0755, true);
            }
            $this->writer->save($path . '/' . $fileName . '.xls');//保存文件
        }

        /**
         *  输出至浏览器下载
         * @param $fileName  保存名称(不含后缀)
         */
        public function export_excel( $fileName){

            $this->browser_export('Excel5', $fileName . '.xls');//输出到浏览器
            $this->writer->save("php://output");
        }

        // 浏览器输出修改头信息
        public function browser_export($type,$filename){
            if($type=="Excel5"){
                header('Content-Type: application/vnd.ms-excel');//告诉浏览器将要输出excel03文件
            }else{
                header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');//告诉浏览器数据excel07文件
            }
            header('Content-Disposition: attachment;filename="'.$filename.'"');//告诉浏览器将输出文件的名称
            header('Cache-Control: max-age=0');//禁止缓存
        }

        public function __destruct() {
            if($this->error != null){
                die(json_encode($this->error));
            }
        }
    }
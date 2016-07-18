
# gridster (未加入angular)

1）动态添加模块（http://gridster.net/demos/adding-widgets-dynamically.html）：使用add_widget方法，通过数组创建一个gridster实例，产生的模块自动排列，无需指定相对位置。
（2）自定义模块内鼠标的拖动区域（http://gridster.net/demos/custom-drag-handle）：鼠标点住模块内指定的元素才可以开始拖动，这样做以免影响模块内其他鼠标动作，比如超链接。
（3）放大悬停模块（http://gridster.net/demos/expandable-widgets.html）：通过resize_widget方法改变鼠标悬停模块的大小
（4）通过JSON序列创建gridster实例（http://gridster.net/demos/grid-from-serialize.html）：通过JSON序列生成一个gridster实例（有了这个方法我们就可以方便的从数据库读取用户的模块位置定义等等）
（5）同一页面放多个拖拽实例（http://gridster.net/demos/multiple-grids.html）：通过配置参数namespace在同一个页面配置多个gridster实例
（6）改变模块大小（http://gridster.net/demos/resize.html）：可以通过拖动改变模块的大小
（7）改变模块大小时添加不同限制（http://gridster.net/demos/resize-limits.html）：你可以使用resize.max_size和resize.min_size配置，以及在模块html当中添加data属性data-max-sizex、data-max-sizey、data-min-sizex、data-min-sizey来限制拖动时模块大小的最大最小值。
（8）输出当前所有模块的位置排布（序列化）（http://gridster.net/demos/serialize.html）：通过serialize方法获取模块的位置信息，可以当作JSON对象使用（这样就可以方便的存储数据）
（9）拖动的回调函数（http://gridster.net/demos/using-drag-callbacks.html）：在开始拖动、拖动结束或位置已改变都可以通过回调函数调用相关的动作，实现一些需要的方法。
（10）改变模块大小后的回调函数（http://gridster.net/demos/using-resize-callbacks.html）：同上，改变模块大小时的回调函数，分为开始、改变、结束三个事件。
（11）动态改变gridster实例的宽度（http://gridster.net/demos/dynamic-grid-width.html）：gridster的列数可以自行定义，这样你可以把模块使劲的~~~往右边拖，直到你设定的最大值。




（英文官方文档：http://gridster.net/#documentation）。


1.widget_selector
示例：widget_selector:"li"
说明：widget_selector用了配置一个girdster里面可拖动模块的html元素名称，支持css选择器，如:widget_selector:"div.drag > .items"。


2.widget_margins
示例：widget_margins:[10,10]
说明：模块的边距，第一个参数是上下边距，第二个参数是左右边距。


3.widget_base_dimensions
示例：widget_base_dimensions:[140,140]
说明：每个模块的基本单位的宽度和高度，拖动或者改变大小都会以这个宽高为一个单位来改变。


autogenerate_stylesheet
示例：autogenerate_stylesheet: true
说明：默认是true，用控制台查看你会发现在head结束前插入了<style>样式代码，大概是这样 [data-col="1"] { left: 10px; }，这些决定了拖动模块的相对位置，如果设置为false，你就要手动的定义这些模块的位置（top和left）


avoid_overlapped_widgets
示例：avoid_overlapped_widgets: true
说明：设置为true，不允许模块叠加，如果两个模块的位置一样（data-col和data-row来决定），程序会自动调整他们的位置，这样可以防止模块错乱。


serialize_params
示例：serialize_params: function($w, wgd) { return { col: wgd.col, row: wgd.row, size_x: wgd.size_x, size_y: wgd.size_y } }
说明：自定义配置序列化的格式，这个函数的返回值将作为返回数组的一个元素，每个模块生成一个元素。使用serialize()方法时才用到此配置，wgd的意思是widget data，gridster通过wgd可以直接取得诸如data-col等的配置，但是如果你想去的模块元素的id，，我们可以通过$w.attr("id")获取。


draggable.start
示例：draggable.start: function(event, ui){}
说明：拖动开始执行的函数


draggable.drag
示例：draggable:{drag: function(event, ui){}}
说明：拖动过程中鼠标移动时执行的函数


draggable.stop
示例：draggable:{stop: function(event, ui){}}
说明：拖动结束后执行的函数


resize.enabled
示例：resize:{enabled: false}
说明：默认false，设置为true时表示可以拖动模块的右下角改变模块大小


resize.axes
示例：resize:{axes: [‘both‘]}
说明：设置改变模块大小时，鼠标可以向X轴还是Y轴移动，意思就是说你可以设置改变模块大小的宽度还是高度，设置为x只能改变模块宽度，设置为y只能改变高度，设置为both高和宽都可以改变。


resize.handle_class
示例：resize:{handle_class: ‘gs-resize-handle‘}
说明：设置改变模块大小时，拖动按钮的classname，默认是gs-resize-handle


resize.handle_append_to
示例：resize:{handle_append_to: ‘‘}
说明：通过css选择器设置一个元素，这个元素将是拖动按钮的父元素，如果不设置，默认是这个模块（也就是widget_selector的值）


resize.max_size
示例：resize:{max_size: [Infinity, Infinity]}
说明：在改变模块大小的时候，为模块的最大宽高做限制


resize.start
示例：resize:{start: function(e, ui, $widget) {}}
说明：鼠标开始拖动大小的时候执行的函数


resize.resize
示例：resize:{resize: function(e, ui, $widget) {}}
说明：大小一旦改变执行的函数


resize.stop
示例：resize:{stop: function(e, ui, $widget) {}}
说明：停止改变大小（释放鼠标）执行的函数
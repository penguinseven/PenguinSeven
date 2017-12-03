/**
 * Created by xieh on 2016/8/30.
 */

$("#color-block").css("background", "#ccc");

// 导出图片
$("#export-grid").click( function () {

    if(!canvasSupport()){
        detail.GLOBAL.cue({
            msg : 'error',
            message : '浏览器不支持图片生成，请使用现代浏览器...'
        });
        return;
    }

    var self = this;

    html2canvas($("#color-block") ,
        {
            onrendered: function(canvas)
            {
                var filename = 'simulation_' + (new Date()).getTime() + '.png';
                $('#down_button').attr( 'href' , canvas.toDataURL() ) ;
                $('#down_button').attr( 'download' , filename ) ;

                $(self).hide();
                $('#down_button').css('display','inline-block');

            }
        });

});

// 判断是否支持canvas
function canvasSupport() {
    return !!document.createElement('canvas').getContext;
}
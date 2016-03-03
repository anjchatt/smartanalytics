$(function() {
    $('.activator').click(function(){
        /* insert 720 page request here */
        $('#overlay').fadeIn('fast',function(){
            $('#popup-box-right').animate({'right':'0', 'left':'10%'},1000);
        });
    });
    $('.boxclose').click(function(){
        $('#popup-box-right').animate({'right':'-100%', 'left':'110%'},200,function(){
            $('#overlay').fadeOut('fast');
        });
    });
});

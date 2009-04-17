HowTo = {
    show: function(type) {
        if ($('#position ul .' + type + ' a').is('.selected')) return
        
        $('#position ul .selected').removeClass('selected')
        $('#position ul .' + type + ' a').addClass('selected')
        
        if (0 == $('.slider.hidden').length) {
            $('.slider:not(.' + type + ')').addClass('hidden');
        } else {
            $('.slider.' + type + ' ~ .slider:not(.hidden)').addClass('right')
            $('.slider:not(.hidden) ~ .slider.' + type).addClass('right')
            $('.slider:not(.hidden)').addClass('sliding')
                .animate({width: '0'}, 400, function() {
                    $(this).removeClass('sliding right').addClass('hidden')
                        .css('width', '32em')
                });
            $('.slider.' + type).removeClass('hidden')
                .addClass('sliding').css('width', '0')
                .animate({width: "32em"}, 400, function() {
                    $(this).removeClass('sliding right')
                });
        }
    },
    check: function() {
        var type = (window.location.hash || "#merb").slice(1)
        HowTo.show(type)
    }
}

$(document).ready(function() {
    if (navigator.userAgent.toLowerCase().match(/windows/)) {
        $('.sudo').hide()
    }
    
    $('#position h3').addClass('hidden')
    
    HowTo.check()
    $('#position ul a').click(function() {
        if ($('.slider').is(':animated')) return
        HowTo.show($(this).parent().attr('class'))
    })
})

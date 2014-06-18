//= require masonry.min

$(function () {
	$(document).foundation();
	var $widgets = $('.masonry');
	$widgets.masonry({
		columnWidth: '.widget-sizer',
		isAnimated: true,
		itemSelector: '.widget'
	});
	$('.widget').each(function () {
		$(this).width($(this).width() - 8);
		$(this).css('margin-left', 4);
		$(this).css('margin-right', 4);
		$(this).css('margin-top', 4);
		$(this).css('margin-bottom', 4);
	});
	new Chartkick.LineChart("saleschart", {"2013-02-10 00:00:00 -0800": 11, "2013-02-11 00:00:00 -0800": 6});
});

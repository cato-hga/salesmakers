function resizeWidgets() {
	var width = $(window).width();
	if (width < 761) {
		return;
	}
	$('.widgets').children('.row').each(function () {
		$(this).find('.large-4 .inner, .large-6 .inner').height('auto');
		var maxHeight = Math.max.apply(Math, $(this).find('.large-4 .inner, .large-6 .inner').map(function () {
			return $(this).height();
		}).get());
		$(this).find('.large-4 .inner, .large-6 .inner').height(maxHeight);
	});
}

function resizeOffCanvas() {
	$('.off-canvas-wrap .inner-wrap').css('min-height', $('aside.left-off-canvas-menu')[0].scrollHeight + 20);
}

$(window).resize(function () {
	resizeWidgets();
	resizeOffCanvas();
});

$(function () {
	resizeOffCanvas();
});

function wrapAndHide(element) {
	element.find('.inner').wrapInner('<div class="collapsed"></div>');
	element.find('.collapsed').hide();
}

function replaceWithCollapsed(element) {
	var collapsed = element.find('.inner .collapsed');
	collapsed.siblings().remove();
	collapsed.show().contents().unwrap();
}

function makeTwoColumn(element) {
	element.switchClass('large-12', 'large-6');
}

function moveToBeginning(element, row) {
	element.prependTo(row);
}

function makeFullWidth(element) {
	element.switchClass('large-4 large-6', 'large-12', 500, 'swing', function () {
		resizeWidgets();
	});
	$('html,body').animate({
		scrollTop: element.offset().top
	}, 300);
	element.find('.inner').prepend('<a class="close">X</a>');
}

function expandWidget(element) {
	wrapAndHide(element);
	var row = element.parent('.row');
	var largeblocks = row.find('.large-12');

	largeblocks.each(function () {
		replaceWithCollapsed($(this));
		makeTwoColumn($(this));
	});

	moveToBeginning(element, row);
	showLoading(element);
	replaceWithData(element);

	row.find('.large-4').not('.large-4:first').each(function () {
		makeTwoColumn($(this));
	});

	makeFullWidth(element);
}

function collapseWidget(element) {
	var row = element.parent('.row');
	var widget_index = element.data('widget-index');
	element.find('.inner .collapsed').show();
	element.find('.inner').html(element.find('.collapsed').show());
	var afterWidget = $(row.find('.widget[data-widget-index="' + (widget_index - 1) + '"]'));
	element.insertAfter(afterWidget);
	row.find('.widget').switchClass('large-12 large-6', 'large-4', 400, 'swing', function () {
		resizeWidgets();
	});
}
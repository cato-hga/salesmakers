// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
// require jquery.turbolinks
//= require jquery_ujs
//= require modernizr
//= require foundation_new/foundation
//= require foundation_new/foundation.offcanvas
//= require foundation_new/foundation.topbar
//= require foundation_new/foundation.dropdown
//= require foundation_new/foundation.tab
//= require foundation_new/foundation.alert
//= require jquery-ui.min
//= require chat
//= require jquery.remotipart
//= require imagesloaded.min
// require turbolinks
// require jquery-ui-datepicker
// require_tree .

function resizeWidgets() {
	var width = $(window).width();
	if( width < 761)
		return;
	$('.widgets').children('.row').each(function () {
		var height = $('.large-4 .inner, .large-6 .inner').height();
		$(this).find('.large-4 .inner, .large-6 .inner').height('auto');
		var maxHeight = Math.max.apply(Math, $(this).find('.large-4 .inner, .large-6 .inner').map(function(){
			return $(this).height();
		}).get());
		$(this).find('.large-4 .inner, .large-6 .inner').height(maxHeight);
	});
}

function resizeOffCanvas() {
    $('.off-canvas-wrap .inner-wrap').css('min-height', $('aside.left-off-canvas-menu')[0].scrollHeight + 20);
}

$(window).resize(function(){
	resizeWidgets();
    resizeOffCanvas();
});

$(function(){
   resizeOffCanvas();
});



$(function(){
	$(document).foundation({
		offcanvas: {
			open_method: 'overlap_single'
		}
	});
	resizeWidgets();
	$('body').on('click', '.expandwidget', function(){
		expandWidget($(this).parents('.widget'));
	});


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

function showLoading(element) {
	element.find('.inner').prepend($('.widget_loading:first').clone().show());

}

function replaceWithData(element) {
	var url = element.data('expand-url');
	$.get(url, function( data ) {
		element.find('.inner').css("height", "auto");
		element.find('.widget_loading').remove();
		$(element).find('.inner').append( data );
		element.find('a.close').click(function() {
			collapseWidget($(this).parents('.widget'));
		});
	});
}

function makeFullWidth(element) {
	element.switchClass('large-4 large-6', 'large-12', 500, 'swing', function(){resizeWidgets()} );
	$('html,body').animate({
		scrollTop: element.offset().top
	}, 300);
	element.find('.inner').prepend('<a class="close">X</a>');
}

function expandWidget(element) {
	wrapAndHide(element);
	var row = element.parent('.row');
	var largeblocks = row.find('.large-12');

	largeblocks.each(function() {
		replaceWithCollapsed($(this));
		makeTwoColumn($(this));
	});

	moveToBeginning(element, row);
	showLoading(element);
	replaceWithData(element);


	row.find('.large-4').not('.large-4:first').each(function(){
		makeTwoColumn($(this));
	});

	makeFullWidth(element);
}

function collapseWidget(element){
	var row = element.parent('.row');
	var widget_index = element.data('widget-index');
	element.find('.inner .collapsed').show();
	element.find('.inner').html(element.find('.collapsed').show());
	var afterWidget = $(row.find('.widget[data-widget-index="' + (widget_index-1) + '"]'));
	element.insertAfter(afterWidget);
	row.find('.widget').switchClass('large-12 large-6', 'large-4', 400, 'swing', function(){resizeWidgets()} );
}


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
//= require foundation
//= require jquery-ui.min
// require turbolinks
// require jquery-ui-datepicker
// require_tree .

function resizeWidgets() {
	$('.widgets').children('.row').each(function () {
		var maxHeight = Math.max.apply(Math, $(this).find('.large-4 .inner, .large-6 .inner').map(function(){ return $(this).height(); }).get());
		$(this).find('.large-4 .inner, .large-6 .inner').height(maxHeight);
	});
}

$(function(){
	$(document).foundation();
	$('a.left-off-canvas-toggle').on('click',function(){

	});
	resizeWidgets();
	$('.expandwidget').click(function(){
		expandWidget($(this).parents('.widget'));

	});
});

function expandWidget(element) {
	element.find('.inner').children().wrap('<div class="collapsed"></div>');
	element.find('.collapsed').hide();
	var row = element.parent('.row');
	row.find('.large-12').find('.inner .collapsed').show();
	row.find('.large-12').find('.inner').html(element.find('.collapsed').show());
	row.find('.large-12').switchClass('large-12', 'large-6');
	element.detach().prependTo(row);
	element.find('.inner').html($('.widget_loading:first').clone().show());
	var url = element.data('expand-url');
	$.get(url, function( data ) {
		element.find('.inner').css("height", "auto");
		element.find('.widget_loading').remove();
		$(element).find('.inner').append( data );
		element.find('a.close').click(function() {
			collapseWidget($(this).parents('.widget'));
		});
	});
	row.find('.large-4').not('.large-4:first').switchClass('large-4', 'large-6', 400);
	element.switchClass('large-4 large-6', 'large-12', 1000, 'swing', function(){resizeWidgets()} );
	$('html,body').animate({
		scrollTop: element.offset().top
	}, 300);
	element.find('.inner').prepend('<a class="close">X</a>');
}

function collapseWidget(element){
	var row = element.parent('.row');
	element.find('.inner .collapsed').show();
	element.find('.inner').html(element.find('.collapsed').show());
	row.find('.widget').switchClass('large-12 large-6', 'large-4', 1000, 'swing', function(){resizeWidgets()} );
}
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
//= require jquery_ujs
//= require jquery.cookie
//= require modernizr
//= require foundation_new/foundation
//= require foundation_new/foundation.offcanvas
//= require foundation_new/foundation.topbar
//= require foundation_new/foundation.dropdown
//= require foundation_new/foundation.tab
//= require foundation_new/foundation.alert
// require chat
//= require imagesloaded.min
//= require magnific
// require websocket_rails/main
//= require classie
//= require notificationFx
//= require jstz
//= require browser_timezone_rails/set_time_zone
//= require map_style
//= require widgets

$(function(){
	$(document).foundation({
		offcanvas: {
			open_method: 'overlap_single'
		}
	});

	$('a').not('[href^="#"]').
		not('[target="_blank"]').
		not('.nested_areas_icon').
		not('a:not([href])').
		not('a[data-attachment]').
		not('.no_loading_indicator').
		on('click', function() {
			$('#page_load').show();
	});

	$('form:not([data-remote])').submit(function() {
		$('#page_load').show();
	});

	resizeWidgets();
	$('body').on('click', '.expandwidget', function(){
		expandWidget($(this).parents('.widget'));
	});

    $('.lightbox_feedback').magnificPopup({
        type:'ajax'
    });

	$('body').on('click', '#show_search', function() {
		$('#search_form').show(250);
	});

	$('body').on('click', '#hide_search', function() {
		$('#search_form').hide(250);
	});

//	$('body').on('click', '.chart_container .toggle_chart', function() {
//		$(this).parents('.chart_container').find('div').toggle();
//	});

	$('body').on('click', '#changelog_dismiss', function() {
		var changelog_dismiss_path = $('#changelog').data('path');
		var authenticity_token = $('#changelog').data('authenticity-token');
		$.ajax({
			type: "PUT",
			url: changelog_dismiss_path,
			data: { authenticity_token: authenticity_token }
		});
	});

	$('body').on('click', '#changelog_dismiss_and_close', function() {
		$('#changelog a.close').click();
	});

});

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
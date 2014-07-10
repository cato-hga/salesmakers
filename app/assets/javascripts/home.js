//= require masonry.min
//= require google_jsapi
//= require chartkick


$(function () {
	$(document).foundation();
	var $widgets = $('.masonry');

	$widgets.masonry({
		columnWidth: '.widget-sizer',
		isAnimated: true,
		itemSelector: '.widget'
	});

	$.get("/widgets/sales", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/hours", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/tickets", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/social", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/alerts", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/image_gallery", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/inventory", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/staffing", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/gaming", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/commissions", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/training", function( data ) {
		$( ".masonry").append( data );
	});

	$.get("/widgets/gift_cards", function( data ) {
		$( ".masonry").append( data );
	});

	//TODO: insure placement order of widgets

	//new Chartkick.LineChart("saleschart", {"2013-02-10 00:00:00 -0800": 11, "2013-02-11 00:00:00 -0800": 6});
});

//= require google_jsapi
//= require chartkick


$(function () {
	$(document).foundation();

	$.get("/widgets/sales", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/hours", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/tickets", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/social", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/alerts", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/image_gallery", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/inventory", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/staffing", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/gaming", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/commissions", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/training", function( data ) {
		$( ".widgets").append( data );
	});

	$.get("/widgets/gift_cards", function( data ) {
		$( ".widgets").append( data );
	});

	//TODO: insure placement order of widgets

});

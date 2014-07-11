//= require google_jsapi
//= require chartkick


$(function () {
	$(document).foundation();

	$.get("/widgets/sales", function( data ) {
		$( "#sales_widget").append( data );
	});

	$.get("/widgets/hours", function( data ) {
		$( "#hours_widget").append( data );
	});

	$.get("/widgets/tickets", function( data ) {
		$( "#tickets_widget").append( data );
	});

	$.get("/widgets/social", function( data ) {
		$( "#social_widget").append( data );
	});

	$.get("/widgets/alerts", function( data ) {
		$( "#alerts_widget").append( data );
	});

	$.get("/widgets/image_gallery", function( data ) {
		$( "#image_gallery_widget").append( data );
	});

	$.get("/widgets/inventory", function( data ) {
		$( "#inventory_widget").append( data );
	});

	$.get("/widgets/staffing", function( data ) {
		$( "#staffing_widget").append( data );
	});

	$.get("/widgets/gaming", function( data ) {
		$( "#gaming_widget").append( data );
	});

	$.get("/widgets/commissions", function( data ) {
		$( "#commissions_widget").append( data );
	});

	$.get("/widgets/training", function( data ) {
		$( "#training_widget").append( data );
	});

	$.get("/widgets/gift_cards", function( data ) {
		$( "#gift_card_widget").append( data );
	});

});

//= require google_jsapi
//= require chartkick
//= require swiper
//= require swiper.3dflow

$(function () {
	$(document).foundation();
	var width = $(window).width();
	var slidesPer = 1;
	if (width > 760) slidesPer = 2;
	if (width > 1270) slidesPer = 3;
	var mySwiper = $('.swiper-container').swiper({
		mode: 'horizontal',
		loop: true,
		centeredSlides: true,
		speed: 600,
		autoplay: 4000,
		slidesPerView: slidesPer,
		tdFlow: {
			rotate: 30,
			depth: 150,
			stretch: 10,
			modifier: 1,
			shadows: true
		}
	});

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
		$( "#gift_cards_widget").append( data );
	});

});

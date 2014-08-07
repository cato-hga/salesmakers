//= require google_jsapi
//= require chartkick
//= require swiper
//= require swiper.3dflow


function outputMessage(message) {
	if (!message['subject']) {
		return;
	}
	console.log(message['subject']);
	var avatar = '';
	if (message['subject']['avatar_url']) {
		avatar = '<img src="' + message['subject']['avatar_url'] + '" class="groupme_avatar">';
	}
	$('#groupme_widget .messages').append('<div class="row full-width groupme_message"><div class="large-2 columns">' + avatar + '</div><div class="large-10 columns"><span class="groupme_name">' + message['subject']['name'] + '</span><span class="groupme_text"></span>' + message['subject']['text'] + '</span></div></div>');
	$('#groupme_widget .inner').animate({
		scrollTop: $('#groupme_widget .messages .groupme_message:last').position().top
	}, 1000);
}


$(function () {
	$(document).foundation();
	var width = $(window).width();
	var slidesPer = 1;
	if (width > 760) slidesPer = 2;
	if (width > 1270) slidesPer = 3;

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

	$.get("/widgets/groupme_slider", function( data ) {
		$('.swiper-placeholder img.loading').hide();
		$( "#groupme_slider_widget").append( data );
		var mySwiper = $('.swiper-container').swiper({
			mode: 'horizontal',
			loop: true,
			centeredSlides: true,
			speed: 600,
			autoplay: 4000,
			slidesPerView: slidesPer,
			calculateHeight: true,
			tdFlow: {
				rotate: 0,
				depth: 300,
				stretch: 0,
				modifier: 1,
				shadows: false
			}
		});
	});

	var pushClient = new GroupmePushClient('7a853610f0ca01310e5a065d7b71239d');
	pushClient.baseUri = "https://push.groupme.com";
	pushClient.subscribe('/user/12486363', {
		message: function(message) { outputMessage(message); }
	});

});

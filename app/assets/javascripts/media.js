// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require swiper

$(function(){
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
		slidesPerView: 'auto',
		calculateHeight: true,
		loopedSlides: 10
	});
});
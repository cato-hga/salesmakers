// require google_jsapi
// require chartkick
// require swiper
// require swiper.3dflow
//= require wall

$(function() {
	$('body').on('click', '#start_tour', function() {
		$(document).foundation('joyride', 'start');
	});
});
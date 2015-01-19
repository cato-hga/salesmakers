// require google_jsapi
// require chartkick
////= require masonry.min
//
//
//$(function () {
//	$(document).foundation();
//
//    var $container = $('.widgets');
//    $container.masonry({
//        columnWidth: ".person_widget",
//        itemSelector: ".widget"
//    });
//
//    resizeWidgets();
//});

//= require wall
//= require google_jsapi
//= require chartkick
//= require masonry.min
//= require underscore.min
//= require google_maps_api.min
//= require marker_clusterer.min
//= require gmaps/google

$(function(){
	$('.nested_areas .nested_areas_icon').bind('click', function(){
		iconElement = $(this).children('i');
		if (iconElement.hasClass('fi-plus')) {
			$(this).parent().children('ul').children('li').show();
			$(this).children('i').removeClass('fi-plus').addClass('fi-minus');
			$('.widgets').masonry('layout');
		} else {
			$(this).parent().children('ul').children('li').hide();
			$(this).children('i').removeClass('fi-minus').addClass('fi-plus');
			$('.widgets').masonry('layout');
		}
	});

	$('.widgets').masonry({
		columnWidth: ".widget",
		itemSelector: ".widget"
	});

	$('#contact_message').on('input propertychange', function() {
		var sms_length = this.value.length;
		var characters_left = 160 - sms_length;
		var sms_length_element = $(this).parents('form').find('.sms_length');
		var submit_element = $(this).parents('form').find('input[type=submit]');
		$(sms_length_element).text(characters_left);
		if (characters_left < 0) {
			$(sms_length_element).removeClass('ok').addClass('bad');
			$(submit_element).attr('disabled', 'disabled');
		} else {
			$(sms_length_element).removeClass('bad').addClass('ok');
			$(submit_element).removeAttr('disabled');
		}
	});

});
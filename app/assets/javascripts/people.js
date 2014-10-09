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

});
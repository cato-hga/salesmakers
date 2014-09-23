// require wall
// TODO: Why does this require wall?

$(function(){
	$('.nested_areas a').bind('click', function(){
		iconElement = $(this).children('i');
		if (iconElement.hasClass('fi-plus')) {
			$(this).parent().next('ul').find('li').show();
			$(this).children('i').removeClass('fi-plus').addClass('fi-minus');
		} else {
			$(this).parent().next('ul').find('li').hide();
			$(this).children('i').removeClass('fi-minus').addClass('fi-plus');
		}
	});
});
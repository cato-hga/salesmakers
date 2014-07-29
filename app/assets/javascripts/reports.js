//= require jquery-ui.min
//= require fieldChooser

$(function() {
	var $sourceCategories = $(".available_categories");
	var $destinationCategories = $(".chosen_categories");
	var $categoriesChooser = $(".categories").fieldChooser($sourceCategories, $destinationCategories);
	var $sourceMetrics = $(".available_metrics");
	var $destinationMetrics = $(".chosen_metrics");
	var $metricsChooser = $(".metrics").fieldChooser($sourceMetrics, $destinationMetrics);

	$('.new_filter').bind('click', function(){
		$('.filters').append($('.filter').html()).removeClass('filter').show();
		$('html, body').animate({
			scrollTop: $('.filters div:last').offset().top
		}, 500);
	});
});


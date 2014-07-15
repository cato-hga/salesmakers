//= require jquery-ui.min
//= require fieldChooser

$(function() {
	$(document).ready(function () {
		var $sourceFields = $(".available_categories");
		var $destinationFields = $(".chosen_categories");
		var $chooser = $(".categories").fieldChooser($sourceFields, $destinationFields);
	});
});
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
	$('body').on('click', '.check_all', function () {
		var checkboxes = $(this).parents('.day').find('input[type=checkbox]');
		if ($(this).prop("checked") === true) {
			checkboxes.each(function () {
				$(this).attr('checked', 'checked');
			});
		} else if ($(this).prop("checked") === false) {
			checkboxes.each(function () {
				$(this).removeAttr('checked');
			});
		}
	});
});
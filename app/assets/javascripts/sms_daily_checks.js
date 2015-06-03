// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
	return $("#sms_check").on("ajax:success", function (e, data, status, xhr) {
		return $("#sms_check").append(xhr.responseText);
	}).on("ajax:error", function (e, xhr, status, error) {
		return $("#new_article").append("<p>ERROR</p>");
	});

	//$('body').on('click', '.check_all', function () {
	//	var checkboxes = $(this).parents('.day').find('input[type=checkbox]');
	//	if ($(this).prop("checked") === true) {
	//		checkboxes.each(function () {
	//			$(this).attr('checked', 'checked');
	//		});
	//	} else if ($(this).prop("checked") === false) {
	//		checkboxes.each(function () {
	//			$(this).removeAttr('checked');
	//		});
	//	}
	//});
});


// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require 'foundation_new/foundation.accordion'

$(function () {
	$('body').on('click', '.save_button', function () {
		saveButton(this);
	});
	$('body').on('click', '.off_button', function () {
		saveButton(this);
	});
});

function saveButton(element) {
	$(element).after("<p class='updating'>Updating...</p>").fadeIn(300);
	$('body').on('ajax:success', 'form[data-remote=true]', function () {
		$('.updating').remove();
		$(element).after("<p class='saved'>Saved!</p>").fadeIn(300);
		$('.saved').delay(3000).fadeOut(300, function () {
			$(this).remove();
		});
		if (element.className == 'button off_button') {
			$(element).parent().parent().parent().parent().parent().find('a.employee_off_area').append(" - EMPLOYEE OFF");
		}
		element = null;
	});
	$('body').on('ajax:failure', 'form[data-remote=true]', function () {
		$('.updating').remove();
		$(element).after("<p class='saved'>Saved Failed!</p>").fadeIn(300);
		$('.saved').delay(3000).fadeOut(300, function () {
			$(this).remove();
		});
		element = null;
	});
}
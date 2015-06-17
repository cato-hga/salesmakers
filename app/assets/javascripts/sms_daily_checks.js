// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require 'jquery-ui/accordion'

$(function () {
	$('body').on('click', '.save_button', function () {
		saveButton(this);
	});
	$('body').on('click', '.off_button', function () {
		saveButton(this);
	});
	$('.togglerow').accordion();
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
			$(element).parent().parent().find('.employee_off_area').delay(50000).after("<br/><strong>EMPLOYEE OFF</strong>").fadeIn(300);
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
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
	$('body').on('click', '.save_button', function () {
		$(this).after("<p class='updating'>Updating...</p>").fadeIn(300);
	});
	$('body').on('ajax:success', 'form[data-remote=true]', function () {
		$('.updating').remove();
		$(this).find('.save_button').after("<p class='saved'>Saved!</p>").fadeIn(300);
		$(this).find('.saved').delay(5000).fadeOut(300);
	});
	$('body').on('ajax:failure', 'form[data-remote=true]', function () {
		$('.updating').remove();
		$(this).find('.save_button').after("<p class='saved'>Save Failed!</p>").fadeIn(300);
		$(this).find('.saved').delay(5000).fadeOut(300);
	});
})
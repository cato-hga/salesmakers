//$(function() {
//
//	$('body').on('ajax:beforeSend', '.new_poll_question_choice, .edit_poll_question_choice', function() {
//		$(this).parents('.choices').find('.alert-box.alert').remove();
//		$(this).find('input[type="submit"]').val('Saving...').attr('disabled', 'disabled');
//	});
//
//	$('body').on('ajax:success', '.new_poll_question_choice', function(ev, data, status, xhr) {
//		$(this)[0].reset();
//		$(data).insertBefore($(this));
//		$(this).find('input[type="submit"]').val('Add').removeAttr('disabled');
//	});
//
//	$('body').on('click', '.choice a.edit_poll_question_choice_link', function() {
//		var choice = $(this).parents('.choice');
//		choice.find('form').show();
//		choice.find('.details').hide();
//	});
//
//	$('body').on('click', '.choice form a.cancel', function() {
//		var choice = $(this).parents('.choice');
//		choice.find('.details').show();
//		choice.find('form').hide();
//	});
//
//	$('body').on('ajax:success', '.edit_poll_question_choice', function(ev, data, status, xhr) {
//		$(this).parents('.choice').replaceWith(data);
//	});
//
//	$('body').on('ajax:error', '.new_poll_question_choice', function(ev, xhr, status, error) {
//		$(xhr.responseText).insertBefore($(this));
//		$(this).find('input[type="submit"]').val('Add').removeAttr('disabled');
//	});
//
//	$('body').on('ajax:error', '.edit_poll_question_choice', function(ev, xhr, status, error) {
//		$(xhr.responseText).insertBefore($(this));
//		$(this).find('input[type="submit"]').val('Save').removeAttr('disabled');
//	});
//});
//= require "application"
$(function () {

	$('#contact_message').on('input propertychange', function () {
		var sms_length = this.value.length;
		var characters_left = 160 - sms_length;
		var sms_length_element = $(this).parents('form').find('.within_length');
		var submit_element = $(this).parents('form').find('input[type=submit]');
		$(sms_length_element).text(characters_left);
		if (characters_left < 0) {
			$(sms_length_element).removeClass('ok').addClass('bad');
			$(submit_element).attr('disabled', 'disabled');
		} else {
			$(sms_length_element).removeClass('bad').addClass('ok');
			$(submit_element).removeAttr('disabled');
		}
	});

});
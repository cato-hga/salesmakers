$(function() {
	$('body').on('click', 'fieldset .select_all', function() {
		$(this).parents('fieldset').find('input[type="checkbox"]').
			attr('checked', 'checked');
	});
	$('body').on('click', 'fieldset .select_none', function() {
		$(this).parents('fieldset').find('input[type="checkbox"]').
			removeAttr('checked');
	});

	$('#message').on('input propertychange', function() {
		var message_length = this.value.length;
		var characters_left = 375 - message_length;
		var message_length_element = $(this).parents('form').find('.within_length');
		var submit_element = $(this).parents('form').find('input[type=submit]');
		$(message_length_element).text(characters_left);
		if (characters_left < 0) {
			$(message_length_element).removeClass('ok').addClass('bad');
			$(submit_element).attr('disabled', 'disabled');
		} else {
			$(message_length_element).removeClass('bad').addClass('ok');
			$(submit_element).removeAttr('disabled');
		}
	});
});
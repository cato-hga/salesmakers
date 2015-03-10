$(function () {

	$('#new_candidate_contact').on('submit', function () {
		$('.alert').remove();
		$(this).find('input[type=submit]').attr('disabled', 'disabled');
	});

	$('#new_candidate_contact').on('ajax:success', function (e, data, status, xhr) {
		$(this).find('#phone_number').show();
	});

	$('#new_candidate_contact').on('ajax:error', function (e, xhr, status, error) {
		$(this).append(xhr.responseText);
		$(this).find('input[type=submit]').removeAttr('disabled');
	});

});
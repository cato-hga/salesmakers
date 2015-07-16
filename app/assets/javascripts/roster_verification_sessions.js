//= require wall

$(function() {
	$('body').on('click', '.save_button', function () {
		var radioNotSelected = false;
		$('.alert.alert-box').removeClass('alert alert-box');
		$('.person').each(function() {
			if (!$(this).find('input:checked').val()) {
				$(this).addClass('alert alert-box');
				radioNotSelected = true;
			}
		});
		if (radioNotSelected) {
			alert('You must select a status for each employee.');
			return false;
		} else {
			return true;
		}
	});

	$('body').on('click', 'input[type="radio"]', function() {
		if ($(this).is('input[value="NOS"]:checked')) {
			$(this).parents('.person').addClass('alert-box warning');
		} else {
			$(this).parents('.person').removeClass('alert-box warning alert');
		}
	});

});
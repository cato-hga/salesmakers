//= require wall

$(function() {
	$('body').on('click', '.save_button', function () {
		var radioNotSelected = false;
		$('.alert.alert-box').removeClass('alert alert-box');

		var active = 0;
		var terminate = 0;
		var issue = 0;

		$('.person').each(function() {
			if ($(this).find('input[type="radio"]').length == 0) {
				return;
			}
			if (!$(this).find('input:checked').val()) {
				$(this).addClass('alert alert-box');
				radioNotSelected = true;
			}
			var checked_value = $(this).find('input[type="radio"]:checked').val();
			switch (checked_value) {
				case 'active':
					active++;
					break;
				case 'terminate':
					terminate++;
					break;
				case 'issue':
					issue++;
					break;
			}
		});
		relayout();
		if (radioNotSelected) {
			alert('You must select a status for each employee.');
			return false;
		}
		var all_issues_selected = true;
		$('.person input[value="issue"]:checked').each(function() {
			var selected = $(this).parents('.person').find('.issue_dropdown select').val();
			if (!selected || selected == '') {
				all_issues_selected = false;
				$(this).parents('.person').addClass('alert-box alert');
			}
		});
		if (!all_issues_selected) {
			alert('You must select an issue from the drop-down for each of the highlighted employees.');
			return false;
		}

		var message = "You are about to verify that you have:\r\n" +
				active.toString() + " active employee(s),\r\n" +
				terminate.toString() + " employee(s) to terminate, and\r\n" +
				issue.toString() + " employee(s) with issues needing to be researched.";
		return confirm(message);
	});

	$('body').on('click', 'input[type="radio"]', function() {
		if ($(this).is('input[value="terminate"]:checked')) {
			$(this).parents('.person').addClass('alert-box warning');
			$(this).parents('.person').find('.issue_dropdown').hide();
		} else if ($(this).is('input[value="issue"]:checked')) {
			$(this).parents('.person').find('.issue_dropdown').show();
			$(this).parents('.person').removeClass('alert-box alert warning');
		} else {
			$(this).parents('.person').removeClass('alert-box warning alert');
			$(this).parents('.person').find('.issue_dropdown').hide();
		}
	});

});
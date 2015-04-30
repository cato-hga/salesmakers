// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
	$('body').on('click', '.check_all', function () {
		var checkboxes = $(this).parents('.day').find('input[type=checkbox]');
		if ($(this).prop("checked") === true) {
			checkboxes.each(function () {
				$(this).attr('checked', 'checked');
			});
		} else if ($(this).prop("checked") === false) {
			checkboxes.each(function () {
				$(this).removeAttr('checked');
			});
		}
	});
	$('#prescreen_answer_worked_for_radioshack').change(function () {
		if (this.value === 'true') {
			$('#prescreen_answer_former_employment_date_start').removeProp("disabled");
			$('#prescreen_answer_former_employment_date_end').removeProp("disabled");
			$('#prescreen_answer_store_number_city_state').removeProp("disabled");
		} else {
			$('#prescreen_answer_former_employment_date_start').prop("disabled", "disabled").val('');
			$('#prescreen_answer_former_employment_date_end').prop("disabled", "disabled").val('');
			$('#prescreen_answer_store_number_city_state').prop("disabled", "disabled").val('');

		}
	});
});


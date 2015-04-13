// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require wall

$(function () {
	var days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
	for (i = 0; i < days.length; ++i) {
		$('#' + days[i] + '_all').click(function () {
			if ($(this).prop("checked") === true) {
				$('#candidate_availability_' + days[i] + '_first').prop('checked', true);
				$('#candidate_availability_' + days[i] + '_second').prop('checked', true);
				$('#candidate_availability_' + days[i] + '_third').prop('checked', true);
			} else if ($(this).prop("checked") === false) {
				$('#candidate_availability_' + days[i] + '_first').prop('checked', false);
				$('#candidate_availability_' + days[i] + '_second').prop('checked', false);
				$('#candidate_availability_' + days[i] + '_third').prop('checked', false);
			}
		})
	}
});

// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
    $(document).foundation();
    $('#monday_all').click(function () {
        if ($(this).prop("checked") == true) {
            $('#candidate_availability_monday_first').prop('checked', true);
            $('#candidate_availability_monday_second').prop('checked', true);
            $('#candidate_availability_monday_third').prop('checked', true);
        }
        else if ($(this).prop("checked") == false) {
            $('#candidate_availability_monday_first').prop('checked', false);
            $('#candidate_availability_monday_second').prop('checked', false);
            $('#candidate_availability_monday_third').prop('checked', false);
        }
    });
    $('#tuesday_all').click(function () {
        if ($(this).prop("checked") == true) {
            $('#candidate_availability_tuesday_first').prop('checked', true);
            $('#candidate_availability_tuesday_second').prop('checked', true);
            $('#candidate_availability_tuesday_third').prop('checked', true);
        }
        else if ($(this).prop("checked") == false) {
            $('#candidate_availability_tuesday_first').prop('checked', false);
            $('#candidate_availability_tuesday_second').prop('checked', false);
            $('#candidate_availability_tuesday_third').prop('checked', false);
        }
    });
    $('#wednesday_all').click(function () {
        if ($(this).prop("checked") == true) {
            $('#candidate_availability_wednesday_first').prop('checked', true);
            $('#candidate_availability_wednesday_second').prop('checked', true);
            $('#candidate_availability_wednesday_third').prop('checked', true);
        }
        else if ($(this).prop("checked") == false) {
            $('#candidate_availability_wednesday_first').prop('checked', false);
            $('#candidate_availability_wednesday_second').prop('checked', false);
            $('#candidate_availability_wednesday_third').prop('checked', false);
        }
    });
    $('#thursday_all').click(function () {
        if ($(this).prop("checked") == true) {
            $('#candidate_availability_thursday_first').prop('checked', true);
            $('#candidate_availability_thursday_second').prop('checked', true);
            $('#candidate_availability_thursday_third').prop('checked', true);
        }
        else if ($(this).prop("checked") == false) {
            $('#candidate_availability_thursday_first').prop('checked', false);
            $('#candidate_availability_thursday_second').prop('checked', false);
            $('#candidate_availability_thursday_third').prop('checked', false);
        }
    });
    $('#friday_all').click(function () {
        if ($(this).prop("checked") == true) {
            $('#candidate_availability_friday_first').prop('checked', true);
            $('#candidate_availability_friday_second').prop('checked', true);
            $('#candidate_availability_friday_third').prop('checked', true);
        }
        else if ($(this).prop("checked") == false) {
            $('#candidate_availability_friday_first').prop('checked', false);
            $('#candidate_availability_friday_second').prop('checked', false);
            $('#candidate_availability_friday_third').prop('checked', false);
        }
    });
    $('#saturday_all').click(function () {
        if ($(this).prop("checked") == true) {
            $('#candidate_availability_saturday_first').prop('checked', true);
            $('#candidate_availability_saturday_second').prop('checked', true);
            $('#candidate_availability_saturday_third').prop('checked', true);
        }
        else if ($(this).prop("checked") == false) {
            $('#candidate_availability_saturday_first').prop('checked', false);
            $('#candidate_availability_saturday_second').prop('checked', false);
            $('#candidate_availability_saturday_third').prop('checked', false);
        }
    });
    $('#sunday_all').click(function () {
        if ($(this).prop("checked") == true) {
            $('#candidate_availability_sunday_first').prop('checked', true);
            $('#candidate_availability_sunday_second').prop('checked', true);
            $('#candidate_availability_sunday_third').prop('checked', true);
        }
        else if ($(this).prop("checked") == false) {
            $('#candidate_availability_sunday_first').prop('checked', false);
            $('#candidate_availability_sunday_second').prop('checked', false);
            $('#candidate_availability_sunday_third').prop('checked', false);
        }
    });
});
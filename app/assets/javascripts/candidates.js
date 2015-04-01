//= require underscore.min
//= require google_maps_api.min
//= require marker_clusterer.min
//= require gmaps/google
//= require sms_counter

//= require wall

$(function () {
    $('form#new_candidate #submit_leave_voicemail').click(function () {
        $('form#new_candidate #select_location').val('false');
        $('form#new_candidate').submit();
    });

    $('body').on('change', '#able_to_attend', function () {
        var able = $(this).val();
        if (able == 'true') {
            $('#unable_to_attend').find('select').each(function () {
                $(this).val('');
            });
            $('#unable_to_attend').find('textarea').each(function () {
                $(this).val('');
            });
            $('#unable_to_attend').hide();
        } else {
            $('#unable_to_attend').show();
        }
    });

    $('body').on('change', '#still_able_to_attend', function () {
        var able = $(this).val();
        if (able == 'true') {
            $('#unable_to_attend').find('select').each(function () {
                $(this).val('');
            });
            $('#unable_to_attend').find('textarea').each(function () {
                $(this).val('');
            });
            $('#unable_to_attend').hide();
        } else {
            $('#unable_to_attend').show();
        }
    });

    var able_to_attend_element = $('#able_to_attend:first-of-type');
    if (able_to_attend_element) {
        var able_to_attend = able_to_attend_element.val();
        if (able_to_attend == 'false') {
            $('#unable_to_attend').show();
        }
    }

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
//= require underscore.min
//= require sms_counter

//= require wall

$(function () {
    $('form#new_candidate #submit_leave_voicemail').click(function () {
        $('form#new_candidate #select_location').val('false');
        $('form#new_candidate').submit();
    });

    $('body').on('change', '#able_to_attend', function () {
        var able = $(this).val();
        if (able === 'true') {
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
        if (able === 'true') {
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
        if (able_to_attend === 'false') {
            $('#unable_to_attend').show();
        }
    }
});
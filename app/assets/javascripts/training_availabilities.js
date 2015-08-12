//= require "application"
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require underscore.min
//= require google_maps_api.min
//= require marker_clusterer.min
//= require gmaps/google
//= require sms_counter

//= require wall

$(function () {
    $('body').on('change', '#training_availability_able_to_attend', function () {
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
});
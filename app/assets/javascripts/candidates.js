//= require underscore.min
//= require google_maps_api.min
//= require marker_clusterer.min
//= require gmaps/google
//= require sms_counter

//= require wall

$(function () {
    $('form#new_candidate #submit_leave_voicemail').click(function () {
        $('form#new_candidate #start_prescreen').val('false');
        $('form#new_candidate').submit();
    });
});
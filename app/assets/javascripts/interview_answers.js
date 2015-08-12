//= require "application"
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require wall

$(function () {
    $('form#new_interview_answer #submit_do_not_extend_offer').click(function () {
        $('form#new_interview_answer #extend_offer').val('false');
        $('form#new_interview_answer').submit();
    });
});
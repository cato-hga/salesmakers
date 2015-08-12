// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


//$(function(){
//   $('.interview_time .hidden').on('click').switchClass('hidden', 'visible')
//});
//
//$('.interview_time .hidden').keypress(function (e) {
//    var key = e.which;
//    if(key == 13)  // the enter key code
//    {
//        $('input[name = butAssignProd]').click();
//        return false;
//    }
//});

$(function () {
	$('body').on('change', '#show_open_time_slots', function () {
		$.cookie('show_open_time_slots', $(this).val());
		location.reload();
	});
	$('body').on('change', '#show_only_missed_interviews', function () {
		$.cookie('show_only_missed_interviews', $(this).val());
		location.reload();
	});
});
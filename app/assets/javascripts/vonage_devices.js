// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// require wall.js
//= require 'jquery-ui'
//= require foundation_new/foundation.reveal

function addRow(button) {
	$('<div class="row full-width vonage_device">' +
		'<div class="large-11 medium-10 small-7 columns"><input type="text" name="mac_id[]" id="mac_id_" placeholder="MAC ID (12 characters, 0-9 &amp; A-F)" class="mac_id"></div>' +
		'<div class="large-1 medium-2 small-5 columns add_delete_button">' +
		'<a class="button postfix add_row">Add</a>' +
		'</div>' +
		'</div>').insertAfter($(button).parents('.vonage_device'));
	$(button).text('Delete').switchClass('add_row', 'delete_row');
	$('.mac_id:last-of-type').focus().select();
}

$(function () {
	$('body').on('click', '.add_row', function () {
		addRow($(this));
	});

	$('body').on('click', '.delete_row', function () {
		$(this).parents('.row').remove();
	});


	$('body').on('keypress', '.mac_id', function (e) {
		if (e.keyCode === 13) {
			addRow($(this).parents('.row').find('.add_row'));
			e.preventDefault();
			return false;
		}
	});
});

$(document).ready(function() {
	$('#select_form').hide();
	$('#change_employee').click(function(event) {
		event.preventDefault();
		$('#select_form').show();
	});
});

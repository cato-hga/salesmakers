//= require wall.js

function addRow(button) {
	$('<div class="row full-width">' +
	'<div class="large-6 columns">' +
	'<input type="text" name="serial[]" id="serial" class="serial_field">' +
	'</div>' +
	'<div class="large-5 columns">' +
	'<input type="text" name="line_identifier[]" id="line_identifier" class="line_id_field">' +
	'</div>' +
	'<div class="large-1 columns">' +
	'<a href="#" class="button postfix add_row">Add</a>' +
	'</div>' +
	'</div>').insertAfter($(button).parents('.row'));
	$(button).text('Delete').switchClass('add_row', 'delete_row');
	$('.serial_field:last-of-type').focus().select();
}

$(function () {
    $('body').on('click', '.add_row', function () {
		addRow($(this));
	});

    $('body').on('click', '.delete_row', function () {
        $(this).parents('.row').remove();
    });

	$('body').on('keypress', '.serial_field', function(e) {
		if (e.keyCode == 13) {
			$(this).parents('.row').find('.line_id_field').focus().select();
			e.preventDefault();
			return false;
		}
	});

	$('body').on('keypress', '.line_id_field', function(e) {
		if (e.keyCode == 13) {
			addRow($(this).parents('.row').find('.add_row'));
			e.preventDefault();
			return false;
		}
	});
});
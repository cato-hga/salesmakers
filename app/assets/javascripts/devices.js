//= require wall.js

function addRow(button) {
    if ($('#secondary_identifier_header').length) {
        addRowWithSecondary(button);
    }
    else {
        addRowWithoutSecondary(button);
    }
}

function addRowWithoutSecondary(button) {
    $('<div class="row full-width">' +
    '<div class="large-6 columns serial_column">' +
    '<input type="text" name="serial[]" id="serial" class="serial_field">' +
    '</div>' +
    '<div class="large-5 columns line_column">' +
    '<input type="text" name="line_identifier[]" id="line_identifier" class="line_id_field">' +
    '</div>' +
    '<div class="large-1 columns add_delete_button">' +
    '<a href="#" class="button postfix add_row">Add</a>' +
    '</div>' +
    '</div>').insertAfter($(button).parents('.row'));
    $(button).text('Delete').switchClass('add_row', 'delete_row');
    $('.serial_field:last-of-type').focus().select();
}

function addRowWithSecondary(button) {
    $('<div class="row full-width">' +
    '<div class="large-4 columns serial_column">' +
    '<input type="text" name="serial[]" id="serial" class="serial_field">' +
    '</div>' +
    '<div class="large-3 columns line_column">' +
    '<input type="text" name="line_identifier[]" id="line_identifier" class="line_id_field">' +
    '</div>' +
    '<div class="large-4 columns secondary_identifier">' +
    '<input type="text" name="secondary_identifier[]" id="secondary_identifier" class="secondary_identifier_field">' +
    '</div>' +
    '<div class="large-1 columns add_delete_button">' +
    '<a href="#" class="button postfix add_row">Add</a>' +
    '</div>' +
    '</div>').insertAfter($(button).parents('.row'));
    $(button).text('Delete').switchClass('add_row', 'delete_row');
    $('.serial_field:last-of-type').focus().select();
}

function secondaryIdentifier() {
    $('<div class="large-4 columns" id="secondary_identifier_header">' +
    '<strong>Secondary Identifier</strong>' +
    '</div>').insertAfter('#line_header');
    $('<div class="large-4 columns secondary_identifier">' +
    '<input type="text" name="secondary_identifier[]" id="secondary_identifier" class="secondary_identifier_field">' +
    '</div>').insertAfter('.line_column');
    $('#serial_header').switchClass('large-6', 'large-4');
    $('#line_header').switchClass('large-6', 'large-4');
    $('.serial_column').switchClass('large-6', 'large-4');
    $('.line_column').switchClass('large-5', 'large-3');
}

$(function () {
    $('body').on('click', '.secondary_identifier_button', function () {
        secondaryIdentifier();
    });

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
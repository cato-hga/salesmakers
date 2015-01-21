//= require wall.js

function addRow(button) {
    if ($('#device_identifier_header').length) {
        addRowWithDevice(button);
    }
    else {
        addRowWithoutDevice(button);
    }
}

function addRowWithoutDevice(button) {
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

function addRowWithDevice(button) {
    $('<div class="row full-width">' +
    '<div class="large-4 columns serial_column">' +
    '<input type="text" name="serial[]" id="serial" class="serial_field">' +
    '</div>' +
    '<div class="large-3 columns line_column">' +
    '<input type="text" name="line_identifier[]" id="line_identifier" class="line_id_field">' +
    '</div>' +
    '<div class="large-4 columns device_identifier">' +
    '<input type="text" name="device_identifier[]" id="device_identifier" class="device_identifier_field">' +
    '</div>' +
    '<div class="large-1 columns add_delete_button">' +
    '<a href="#" class="button postfix add_row">Add</a>' +
    '</div>' +
    '</div>').insertAfter($(button).parents('.row'));
    $(button).text('Delete').switchClass('add_row', 'delete_row');
    $('.serial_field:last-of-type').focus().select();
}

function deviceIdentifier() {
    $('<div class="large-4 columns" id="device_identifier_header">' +
    '<strong>Device Identifier</strong>' +
    '</div>').insertAfter('#line_header');
    $('<div class="large-4 columns device_identifier">' +
    '<input type="text" name="device_identifier[]" id="device_identifier" class="device_identifier_field">' +
    '</div>').insertAfter('.line_column');
    $('#serial_header').switchClass('large-6', 'large-4');
    $('#line_header').switchClass('large-6', 'large-4');
    $('.serial_column').switchClass('large-6', 'large-4');
    $('.line_column').switchClass('large-5', 'large-3');
}

$(function () {
    $('body').on('click', '.device_identifier_button', function () {
        deviceIdentifier();
    });

    $('body').on('click', '.add_row', function () {
        addRow($(this));
    });

    $('body').on('click', '.delete_row', function () {
        $(this).parents('.row').remove();
    });

    $('body').on('keypress', '.serial_field', function (e) {
        if (e.keyCode == 13) {
            $(this).parents('.row').find('.line_id_field').focus().select();
            e.preventDefault();
            return false;
        }
    });

    $('body').on('keypress', '.line_id_field', function (e) {
        if ($('#device_identifier_header').length) {
            if (e.keyCode == 13) {
                $(this).parents('.row').find('.device_identifier_field').focus().select();
                e.preventDefault();
                return false;
            }

        } else if (e.keyCode == 13) {
            addRow($(this).parents('.row').find('.add_row'));
            e.preventDefault();
            return false;
        }
    });

    $('body').on('keypress', '.device_identifier_field', function (e) {
        if (e.keyCode == 13) {
            addRow($(this).parents('.row').find('.add_row'));
            e.preventDefault();
            return false;
        }
    });
});
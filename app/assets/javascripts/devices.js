//= require wall.js

$(function () {
    $('body').on('click', '.add_row', function () {
        $('<div class="row full-width">' +
        '<div class="large-6 columns">' +
        '<input type="text" name="serial" id="serial" class="serial_field">' +
        '</div>' +
        '<div class="large-5 columns">' +
        '<input type="text" name="line_identifier" id="line_identifier" class="line_id_field">' +
        '</div>' +
        '<div class="large-1 columns">' +
        '<a href="#" class="button postfix add_row">Add</a>' +
        '</div>' +
        '</div>').insertAfter($(this).parents('.row'));
        $(this).text('Delete').switchClass('add_row', 'delete_row');
    });
});
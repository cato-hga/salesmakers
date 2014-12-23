//= require wall.js
$(function () {
    $('body').on('click', '.add_row', function () {
        $('<div class="row full-width">' +
        '<div class="large-6 columns">' +
        '<input type="text" name="serial[]" id="serial_" class="serial_field">' +
        '</div>' +
        '<div class="large-5 columns">' +
        '<input type="text" name="line[]" id="line_" class="line_field">' +
        '</div>' +
        '<div class="large-1 columns">' +
        '<a href="#" class="button postfix add_row">Add</a>' +
        '</div>' +
        '</div>').insertAfter($(this).parents('.row'));
        $(this).text('Delete').switchClass('add_row', 'delete_row');
        $('body').on('click', '.delete_row', function () {
            $(this).parents('.row').remove();
        });
    });
});
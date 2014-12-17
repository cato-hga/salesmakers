//= require wall.js
$(function () {
    $('body').on('click', '.add_row', function () {
        $('<div class="row full-width">' +
        '<div class="large-11 columns">' +
        '<input type="text" name="line[identifier]" id="line_identifier" class="line_field">' +
        '</div>' +
        '<div class="large-1 columns">' +
        '<a href="#" class="button postfix add_row">Add</a>' +
        '</div>' +
        '</div>').insertAfter($(this).parents('.row'));
        $(this).text('Delete').switchClass('add_row', 'delete_row');
    });
});
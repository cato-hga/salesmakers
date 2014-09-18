// require google_jsapi
// require chartkick
//= require masonry.min


$(function () {
	$(document).foundation();

    var $container = $('.widgets');
    $container.masonry({
        columnWidth: ".person_widget",
        itemSelector: ".widget"
    });

    resizeWidgets();
});
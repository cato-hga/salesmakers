//= require google_jsapi
//= require chartkick
//= require swiper
//= require swiper.3dflow
//= require masonry.min
//= require readmore

$(function () {
	$(document).foundation();

	var $container = $('.wall');

	$('.wall_post .post_content').readmore({
		maxHeight: 500,
		heightMargin: 100,
		moreLink: '<a href="#">More</a>',
		afterToggle: function(){
			$container.masonry(

			);
		}
	});

	$container.masonry({
		columnWidth: ".wall_post",
		itemSelector: ".widget"
	});

    $(document).on('ajax:remotipartSubmit', 'form', function(evt, xhr, settings){
        settings.dataType = 'html *';
    });

    $('#new_text_post').on('ajax:success', function(e, data, status, xhr){
        var $new_post = $('#new_text_post').parents('.widget').after(xhr.responseText);
        $container.masonry('reloadItems');
        $container.masonry('layout');
        $('#new_text_post')[0].reset();
    }).on('ajax:error', function(e, xhr, status, error){
        $('#new_text_post').append(xhr.responseText);
        $container.masonry('reloadItems');
        $container.masonry('layout');
    });
    
    $('#new_uploaded_image').on('ajax:success', function(e, data, status, xhr){
        var $new_post = $('#new_uploaded_image').parents('.widget').after(xhr.responseText);
        imagesLoaded($new_post, function(){
            $container.masonry('reloadItems');
            $container.masonry('layout');
        });
        $('#new_uploaded_image')[0].reset();
    }).on('ajax:error', function(e, xhr, status, error){
        $('#new_uploaded_image').append(xhr.responseText);
        $container.masonry('reloadItems');
        $container.masonry('layout');
    });

    $('#new_uploaded_video').on('ajax:success', function(e, data, status, xhr){
        var $new_post = $('#new_uploaded_video').parents('.widget').after(xhr.responseText);
        $container.masonry('reloadItems');
        $container.masonry('layout');
        $('#new_uploaded_video')[0].reset();
    }).on('ajax:error', function(e, xhr, status, error){
        $('#new_uploaded_video').append(xhr.responseText);
        $container.masonry('reloadItems');
        $container.masonry('layout');
    });

    $('#new_text_post, #new_uploaded_image, #new_uploaded_video').submit(function(){
       $(this).parents('.widget').find('.alert-box').remove();
    });
});

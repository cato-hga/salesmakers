//= require masonry.min
//= require readmore

$(function () {
    $(document).foundation();

    var $container = $('.widgets');

    $('.widget .post_content').readmore({
        maxHeight: 500,
        heightMargin: 100,
        moreLink: '<a href="#">More</a>',
        afterToggle: function(){
            $container.masonry(

            );
        }
    });

    $container.masonry({
        columnWidth: ".widget",
        itemSelector: ".widget"
    });

    $(document).on('ajax:remotipartSubmit', 'form', function(evt, xhr, settings){
        settings.dataType = 'html *';
    });

    $('#new_text_post').on('ajax:success', function(e, data, status, xhr){
        var $new_post = $('#new_text_post').parents('.widget').after(xhr.responseText);
		imagesLoaded($container, function(){
			$container.masonry('reloadItems');
			$container.masonry('layout');
		});
		$('#new_text_post')[0].reset();
    }).on('ajax:error', function(e, xhr, status, error){
        $('#new_text_post').append(xhr.responseText);
        $container.masonry('reloadItems');
        $container.masonry('layout');
    });

    $('#new_uploaded_image').on('ajax:success', function(e, data, status, xhr){
        var $new_post = $('#new_uploaded_image').parents('.widget').after(xhr.responseText);
        imagesLoaded($container, function(){
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
		imagesLoaded($container, function(){
			$container.masonry('reloadItems');
			$container.masonry('layout');
		});
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

function setupUnlikeEvent(post_id) {
    $('#unlike-' + post_id).on('ajax:success', function(event, xhr, data, status) {
        $('#unlike-' + post_id).css('color', '#dddddd').switchClass('liked', 'unliked').attr('href', '/like/' + post_id);
        $('#unlike-' + post_id).off('ajax:success');
        var current_count = parseInt($('#unlike-' + post_id).parents('.post_actions').find('.count').html());
        current_count--;
        $('#unlike-' + post_id).parents('.post_actions').find('.count').html(current_count);
        $('#unlike-' + post_id).attr('id', 'like-' + post_id);
        setupLikeEvent(post_id);
    });
}

function setupLikeEvent(post_id) {
    $('#like-' + post_id).on('ajax:success', function(event, xhr, data, status) {
        $('#like-' + post_id).css('color', '#ffcc00').switchClass('unliked', 'liked').attr('href', '/unlike/' + post_id);
        $('#like-' + post_id).off('ajax:success');
        var current_count = parseInt($('#like-' + post_id).parents('.post_actions').find('.count').html());
        current_count++;
        $('#like-' + post_id).parents('.post_actions').find('.count').html(current_count);
        $('#like-' + post_id).attr('id', 'unlike-' + post_id);
        setupUnlikeEvent(post_id);
    });
}
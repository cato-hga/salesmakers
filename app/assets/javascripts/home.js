//= require google_jsapi
//= require chartkick
//= require swiper
//= require swiper.3dflow
//= require masonry.min
//= require readmore

function outputMessage(message) {
	if (!message['subject']) {
		return;
	}
	var subject = message['subject'];
	if (subject['name'] == 'GroupMe') {
		return;
	}
	console.log(subject);
	var avatar = '';
	var text = '';
	if (subject['avatar_url']) {
		avatar = '<img src="' + subject['avatar_url'] + '" class="groupme_avatar avatar">';
	}
	if (subject['text']) {
		text = subject['text'];
	}
	if (subject['picture_url']) {
		text += '<img src="' + subject['picture_url'] + '" class="groupme_image">';
	}

}


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

    $('#new_text_post').on('ajax:success', function(e, data, status, xhr){
        var $new_post = $('#new_text_post').parents('.widget').after(xhr.responseText);
        $container.masonry('reloadItems');
        $container.masonry('layout');
    }).on('ajax:error', function(e, xhr, status, error){
        $('#new_text_post').append(xhr.responseText);
    });
    
    $('#new_uploaded_image').on('ajax:success', function(e, data, status, xhr){
        var $new_post = $('#new_uploaded_image').parents('.widget').after(xhr.responseText);
        $container.masonry('reloadItems');
        $container.masonry('layout');
    }).on('ajax:error', function(e, xhr, status, error){
        $('#new_uploaded_image').append(xhr.responseText);
    });
    
    $('#new_uploaded_video').on('ajax:success', function(e, data, status, xhr){
        var $new_post = $('#new_uploaded_video').parents('.widget').after(xhr.responseText);
        $container.masonry('reloadItems');
        $container.masonry('layout');
    }).on('ajax:error', function(e, xhr, status, error){
        $('#new_uploaded_video').append(xhr.responseText);
    });
});

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
});

//GroupMe Widget - saving code
//
//$('#groupme_widget .messages').append('<div class="row full-width groupme_message"><div class="large-2 columns">'
//      + avatar + '</div><div class="large-10 columns"><span class="groupme_name">' + subject['name'] + '</span><
//      span class="groupme_text"></span>' + text + '</span></div></div>');
//$('#groupme_widget .inner').animate({
//    scrollTop: $('#groupme_widget .inner')[0].scrollHeight
//}, 1000);
//
//var pushClient = new GroupmePushClient('7a853610f0ca01310e5a065d7b71239d');
//pushClient.baseUri = "https://push.groupme.com";
//pushClient.subscribe('/user/12486363', {
//    message: function(message) { outputMessage(message); }
//});

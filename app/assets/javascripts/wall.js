//= require "application"
//= require masonry.min
//= require imagesloaded.min

////= require readmore
//
$(function () {
    $(document).foundation();
//
    window.$container = $('.widgets');
	var $container = window.$container;
//
//    $('.widget .post_content').readmore({
//        maxHeight: 500,
//        heightMargin: 100,
//        moreLink: '<a href="#">More</a>',
//        afterToggle: function(){
//            $container.masonry(
//
//            );
//        }
//    });
//
	$container.masonry({
		columnWidth: ".widget",
		itemSelector: ".widget"
	});
//
	imagesLoaded($container, function() {
		relayout();
	});
//
//	$('body').on('submit', 'form[data-remote=true]', function() {
//		submitToLoading($(this));
//	});
//
//	$('#new_text_post, #new_uploaded_image, #new_uploaded_video, #new_link_post').on('ajax:complete', function(e) {
//		$(this).find('input[type=submit]').attr('value', 'Share');
//	});
//
//	$('.new_wall_post_comment').on('ajax:complete', function(e) {
//		$(this).find('input[type=submit]').attr('value', 'Save');
//	});
//
//    $(document).on('ajax:remotipartSubmit', 'form', function(evt, xhr, settings){
//        settings.dataType = 'html *';
//    });
//
//    $('#new_text_post, #new_uploaded_image, #new_uploaded_video, #new_link_post').on('ajax:success', function(e, data, status, xhr){
//        var $new_post = $('#insert_posts_after').after(xhr.responseText);
//		imagesLoaded($container, function(){
//			relayout();
//		});
//		$(this)[0].reset();
//    }).on('ajax:error', function(e, xhr, status, error){
//        $(this).append(xhr.responseText);
//		relayout();
//    }).submit(function(){
//		$(this).parents('.widget').find('.alert-box').remove();
//	});
//
//	$('body').on('click', '.widget .show_wall_post_comment_form', function() {
//		$(this).hide();
//		$(this).parents('.widget').find('.wall_post_comment_form').show();
//		relayout();
//	});
//
//    //Editing Wall Post
//	$('body').on('click', '.widget .show_wall_post_edit_form', function() {
//		$(this).hide();
//		$(this).parents('.wall_post_comment').find('.edit_comment_form').find('.wall_post_edit_comment_form').show();
//		$container.masonry('layout');
//	});
//
//    $('body').on('ajax:success', '.new_wall_post_comment', function(e, data, status, xhr) {
//        var $new_wall_post_comment = $(this).parents('.widget').find('.comments').append(xhr.responseText);
//        hideCommentForm($(this).parents('.wall_post_comment_form'));
//        relayout();
//    }).on('ajax:error', '.new_wall_post_comment', function(e, xhr, status, error) {
//        $(this).append(xhr.responseText);
//        relayout();
//    });
//
//    $('body').on('ajax:success', '.edit_wall_post_comment', function(e, data, status, xhr) {
//        var $edited_wall_post_comment = $(this).parents('.wall_post_comment').replaceWith(xhr.responseText);
//        hideEditCommentForm($(this).parents('.wall_post_edit_comment_form'));
//        relayout();
//    }).on('ajax:error', '.new_wall_post_comment', function(e, xhr, status, error) {
//        $(this).append(xhr.responseText);
//        relayout();
//    });
//
//    $('body').on('click', '.show_change_wall_form', function(){
//        $(this).parents('.widget').find('.change_wall_form').show();
//        $(this).hide();
//		relayout();
//    });
//
//    $('body').on('click', '.change_wall_submit', function() {
//        linkToLoading($(this));
//		var form = $(this).parents('.change_wall_form');
//        var wall_post_id = form.find('.change_wall_form_wall_post_id').val();
//        var wall_id = form.find('.change_wall_form_wall_id').val();
//        window.location.href = '/wall_posts/' + wall_post_id + '/promote/' + wall_id;
//    });
//
//	$('body').on('click', '.wall_post_comment_form .cancel', function() {
//		hideCommentForm($(this).parents('.wall_post_comment_form'));
//	});
//
//	$('body').on('click', '.wall_post_edit_comment_form .cancel', function() {
//		hideEditCommentForm($(this).parents('.wall_post_edit_comment_form'));
//	});
//
//	$('body').on('click', '.change_wall_form .cancel', function() {
//		hideChangeWallForm($(this).parents('.change_wall_form'));
//	});
//
//	$('.lightbox').magnificPopup({
//		type: 'image'
//	});
//
//	$('body').on('click', '.show_new_posts', function() {
//		$('.widget.hidden').removeClass('hidden').show();
//		relayout();
//		window.new_post_notification.dismiss();
//	});
//
});
//
function relayout() {
	$container.masonry('reloadItems').masonry('layout');
}

//function hideCommentForm(form) {
//	form.hide();
//	form.find('form')[0].reset();
//	form.parents('.widget').find('.show_wall_post_comment_form').show();
//	relayout();
//}
//
//function hideEditCommentForm(form) {
//	form.hide();
//	form.find('form')[0].reset();
//	form.parents('.widget').find('.show_wall_post_edit_form').show();
//	relayout();
//}
//
//function hideChangeWallForm(form) {
//	form.hide();
//	form.parents('.widget').find('.show_change_wall_form').show();
//	relayout();
//}
//
//function linkToLoading(button) {
//	button.text('Saving...').click(function(e) {
//		e.preventDefault();
//	})
//}
//
//function submitToLoading(form) {
//	form.find('input[type=submit]').attr('value', 'Saving...');
//}
//
//function setupUnlikeEvent(post_id) {
//	$('#unlike-' + post_id).on('ajax:success', function(event, xhr, data, status) {
//        $('#unlike-' + post_id).css('color', '#dddddd').switchClass('liked', 'unliked').attr('href', '/like/' + post_id);
//        $('#unlike-' + post_id).off('ajax:success');
//        var current_count = parseInt($('#unlike-' + post_id).parents('.post_actions').find('.count').html());
//        current_count--;
//        $('#unlike-' + post_id).parents('.post_actions').find('.count').html(current_count);
//        $('#unlike-' + post_id).attr('id', 'like-' + post_id);
//        setupLikeEvent(post_id);
//    });
//}
//
//function setupLikeEvent(post_id) {
//    $('#like-' + post_id).on('ajax:success', function(event, xhr, data, status) {
//        $('#like-' + post_id).css('color', '#ffcc00').switchClass('unliked', 'liked').attr('href', '/unlike/' + post_id);
//        $('#like-' + post_id).off('ajax:success');
//        var current_count = parseInt($('#like-' + post_id).parents('.post_actions').find('.count').html());
//        current_count++;
//        $('#like-' + post_id).parents('.post_actions').find('.count').html(current_count);
//        $('#like-' + post_id).attr('id', 'unlike-' + post_id);
//        setupUnlikeEvent(post_id);
//    });
//}
//
//function notify(post_count) {
//	if ($('#new_post_count').length > 0) {
//		$('#new_post_count').text(post_count);
//	} else {
//		window.new_post_notification = new NotificationFx({
//			message: '<p><span id="new_post_count">' + post_count + '</span> new posts. <a class="show_new_posts">[show]</a>',
//			layout: 'growl',
//			effect: 'genie',
//			type: 'notice',
//			ttl: 300000,
//			wrapper: document.getElementById('main_container')
//		});
//		window.new_post_notification.show();
//	}
//}
//
//function placePost(id) {
//	$.ajax({
//		url: '/wall_posts/' + id
//	}).done(function(data) {
//		if ($('#insert_posts_after').length > 0) {
//			$('#insert_posts_after').after(data);
//		} else {
//			$('.widgets').prepend(data);
//		}
//		var new_post_count = $('.widget.hidden').length;
//		notify(new_post_count);
//	});
//}
//= require masonry.min
//= require readmore

$(function () {
    $(document).foundation();

    window.$container = $('.widgets');

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

	imagesLoaded($container, function() {
		relayout();
	});

	$('body').on('submit', 'form[data-remote=true]', function() {
		submitToLoading($(this));
	});

	$('#new_text_post, #new_uploaded_image, #new_uploaded_video').on('ajax:complete', function(e) {
		$(this).find('input[type=submit]').attr('value', 'Share');
	});

	$('.new_wall_post_comment').on('ajax:complete', function(e) {
		$(this).find('input[type=submit]').attr('value', 'Save');
	});

    $(document).on('ajax:remotipartSubmit', 'form', function(evt, xhr, settings){
        settings.dataType = 'html *';
    });

    $('#new_text_post, #new_uploaded_image, #new_uploaded_video').on('ajax:success', function(e, data, status, xhr){
        var $new_post = $(this).parents('.widget').after(xhr.responseText);
		imagesLoaded($container, function(){
			relayout();
		});
		$(this)[0].reset();
    }).on('ajax:error', function(e, xhr, status, error){
        $(this).append(xhr.responseText);
		relayout();
    }).submit(function(){
		$(this).parents('.widget').find('.alert-box').remove();
	});

	$('body').on('click', '.widget .show_wall_post_comment_form', function() {
		$(this).hide();
		$(this).parents('.widget').find('.wall_post_comment_form').show();
		relayout();
	});

    //Editing Wall Post
	$('body').on('click', '.widget .show_wall_post_edit_form', function() {
		$(this).hide();
		$(this).parents('.wall_post_comment').find('.edit_comment_form').find('.wall_post_edit_comment_form').show();
		$container.masonry('layout');
	});

    $('body').on('ajax:success', '.new_wall_post_comment', function(e, data, status, xhr) {
        var $new_wall_post_comment = $(this).parents('.widget').find('.comments').append(xhr.responseText);
        hideCommentForm($(this).parents('.wall_post_comment_form'));
        relayout();
    }).on('ajax:error', '.new_wall_post_comment', function(e, xhr, status, error) {
        $(this).append(xhr.responseText);
        relayout();
    });

    $('body').on('ajax:success', '.edit_wall_post_comment', function(e, data, status, xhr) {
        var $edited_wall_post_comment = $(this).parents('.wall_post_comment').replaceWith(xhr.responseText);
        hideEditCommentForm($(this).parents('.wall_post_edit_comment_form'));
        relayout();
    }).on('ajax:error', '.new_wall_post_comment', function(e, xhr, status, error) {
        $(this).append(xhr.responseText);
        relayout();
    });

    $('body').on('click', '.show_change_wall_form', function(){
        $(this).parents('.widget').find('.change_wall_form').show();
        $(this).hide();
		relayout();
    });

    $('body').on('click', '.change_wall_submit', function() {
        linkToLoading($(this));
		var form = $(this).parents('.change_wall_form');
        var wall_post_id = form.find('.change_wall_form_wall_post_id').val();
        var wall_id = form.find('.change_wall_form_wall_id').val();
        window.location.href = '/wall_posts/' + wall_post_id + '/promote/' + wall_id;
    });

	$('body').on('click', '.wall_post_comment_form .cancel', function() {
		hideCommentForm($(this).parents('.wall_post_comment_form'));
	});

	$('body').on('click', '.wall_post_edit_comment_form .cancel', function() {
		hideEditCommentForm($(this).parents('.wall_post_edit_comment_form'));
	});

	$('body').on('click', '.change_wall_form .cancel', function() {
		hideChangeWallForm($(this).parents('.change_wall_form'));
	});
});

function relayout() {
	$container.masonry('reloadItems').masonry('layout');
}

function hideCommentForm(form) {
	form.hide();
	form.find('form')[0].reset();
	form.parents('.widget').find('.show_wall_post_comment_form').show();
	relayout();
}

function hideEditCommentForm(form) {
	form.hide();
	form.find('form')[0].reset();
	form.parents('.widget').find('.show_wall_post_edit_form').show();
	relayout();
}

function hideChangeWallForm(form) {
	form.hide();
	form.parents('.widget').find('.show_change_wall_form').show();
	relayout();
}

function linkToLoading(button) {
	button.text('Saving...').click(function(e) {
		e.preventDefault();
	})
}

function submitToLoading(form) {
	form.find('input[type=submit]').attr('value', 'Saving...');
}

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


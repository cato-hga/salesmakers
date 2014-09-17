//= require faye
//= require group_me_push_client

function populate_groups(){
    $('#chat_aside').html(
        '<div class="chat_loading"><img src="/assets/loading.gif" alt="Loading"><br/><p>Loading...</p></div>'
        );
    $.get("/group_mes/groups_aside", function (data) {
        $("#chat_aside").html(data);
    });
}

$(function(){
    populate_groups();

    $('body').on('click', '.group_preview .group_avatar, .group_preview .timestamp, .group_preview .heading,' +
                ' .group_preview .content', function(){
        preview = $(this).parents('.group_preview');
        $(preview).find('.content, .timestamp').remove();
        $(preview).find('a.close').show();
        $(preview).siblings().remove();
        $('#chat_aside').append(
            '<div class="chat_loading"><img src="/assets/loading.gif" alt="Loading"><br/><p>Loading...</p></div>'
        );
        var group_id = $(preview).data('group-id');
        $.get("/group_mes/group_chat_aside/" + group_id, function (data) {
            $('#chat_aside .chat_loading').remove();
            $("#chat_aside").append(data);
        });
    });

    $('body').on('click', '#chat_aside a.close', function(){
        populate_groups();
    });

    var access_token = $('input#group_me_access_token').val();
    var group_me_user_id = $('input#group_me_user_id').val();
    if(access_token){
        var pushClient = new GroupmePushClient(access_token);
        pushClient.baseUri = "https://push.groupme.com";
        pushClient.subscribe('/user/' + group_me_user_id, {
            message: function(message) { outputMessage(message); }
        });
    }

	$('body').on('ajax:complete', '#group_me_post', function(event, xhr, status) {
		$('#group_me_post')[0].reset();
	});
});

function zeroFill( number, width )
{
	width -= number.toString().length;
	if ( width > 0 )
	{
		return new Array( width + (/\./.test( number ) ? 2 : 1) ).join( '0' ) + number;
	}
	return number + ""; // always return a string
}

function formatAMPMDate(date) {
	var strTime = zeroFill(date.getMonth(), 2)
		+ '/'
		+ zeroFill(date.getDate(), 2)
		+ '/'
		+ zeroFill(date.getFullYear(), 4)
		+ ' ';
	var hours = date.getHours();
	var minutes = date.getMinutes();
	var ampm = hours >= 12 ? 'pm' : 'am';
	hours = hours % 12;
	hours = hours ? hours : 12; // the hour '0' should be '12'
	minutes = minutes < 10 ? '0'+minutes : minutes;
	strTime += hours + ':' + minutes + ' ' + ampm;
	return strTime;
}

function outputMessage(message){
    if(message['type'] != 'line.create'){
        return;
    }
    var preview = $('.group_preview[data-group-id=' + message['subject']['group_id'] + ']');
    var chat = $('.group_chat[data-group-id=' + message['subject']['group_id'] + ']');
    var preview_content = '<strong>' + message['subject']['name'];
	if ((message['subject']['attachments'] != null)
		&& (message['subject']['attachments'].length > 0)
		&& (message['subject']['attachments'][0]['type'] == 'image')) {
		preview_content += '</strong> posted an image.';
	} else {
		preview_content += ':</strong> ' + message['subject']['text'];
	}
	preview.find('.content').html(preview_content);
    console.log(JSON.stringify(message));

    preview.prependTo('#chat_aside');
    // console.log(message['subject']['name'] + ': ' + message['subject']['text']);
    if(chat.length > 0) {
		var sent = new Date(message['subject']['created_at']*1000);
        var content = '<div class="row full-width chat_message">'
          +  '<div class="large-2 columns centered_text">'
          +  '<img src="'
		+ message['subject']['avatar_url']
		+ '" class="chat_avatar">'
          +  '</div>'
          +  '<div class="large-10 columns">'
          +  '<strong class="small">'
		+ message['subject']['name']
		+ '</strong>'
          +  '<div class="timestamp small comment right">'
          +  formatAMPMDate(sent)
      +  '</div>'
      +  '<div class="content">';
		if ((message['subject']['attachments'] != null)
			&& (message['subject']['attachments'].length > 0)
			&& (message['subject']['attachments'][0]['type'] == 'image')) {
			content += '<img src="'
				+ message['subject']['attachments'][0]['url']
				+ '.large">'
		}
		if (message['subject']['text'] != null) {
			content += '<div>' + message['subject']['text'] + '</div>';
		}
      content +=  '</div>'
      +  '</div>'
      +  '</div>';
		chat.prepend(content);
    }
}
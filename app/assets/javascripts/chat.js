//= require faye
//= require group_me_push_client

function codePointAt(text, position) {
	if (text == null) {
		throw TypeError();
	}
	var string = String(text);
	var size = string.length;
	// `ToInteger`
	var index = position ? Number(position) : 0;
	if (index != index) { // better `isNaN`
		index = 0;
	}
	// Account for out-of-bounds indices:
	if (index < 0 || index >= size) {
		return undefined;
	}
	// Get the first code unit
	var first = string.charCodeAt(index);
	var second;
	if ( // check if it’s the start of a surrogate pair
		first >= 0xD800 && first <= 0xDBFF && // high surrogate
		size > index + 1 // there is a next code unit
		) {
		second = string.charCodeAt(index + 1);
		if (second >= 0xDC00 && second <= 0xDFFF) { // low surrogate
			// http://mathiasbynens.be/notes/javascript-encoding#surrogate-formulae
			return (first - 0xD800) * 0x400 + second - 0xDC00 + 0x10000;
		}
	}
	return first;
};

function replaceEmojiUnicode(text) {
	text = text.replace(/([\u2002-\u3299])/g, function(match) {
		var code = match.charCodeAt(0);
		var codeHex = code.toString(16).toLowerCase();
		while (codeHex.length < 4) {
			codeHex = "0" + codeHex;
		}
		return '<img src="https://d2xk3mdboeujlo.cloudfront.net/images/emoji/64/' + codeHex + '.png" class="emoji">';
	});
	text = text.replace(/([\ud800-\udbff][\udc00-\udfff])/g, function(match) {
		var code = codePointAt(match, 0);
		var codeHex = code.toString(16).toLowerCase();
		while (codeHex.length < 4) {
			codeHex = "0" + codeHex;
		}
		return '<img src="https://d2xk3mdboeujlo.cloudfront.net/images/emoji/64/' + codeHex + '.png" class="emoji">';
	});
	return text;
}

function populate_groups(){
    $('#chat_aside').html(
        '<div class="chat_loading"><img src="/assets/loading.gif" alt="Loading"><br/><p>Loading...</p></div>'
        );
	// [\uf0cf-\uffff]
    $.get("/group_mes/groups_aside", function (data) {
        data = replaceEmojiUnicode(data);
		$("#chat_aside").html(data);
    });
}

$(function(){
	window.powerups = (function() {
		var powerups = null;
		$.ajax({
			'async': false,
			'global': false,
			'url': 'https://powerup.groupme.com/powerups',
			'dataType': 'json',
			'success': function(data) {
				powerups = data;
				powerups = powerups['powerups'];
			}
		});
		return powerups;
	})();

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
            $("#chat_aside").append(replaceEmojiUnicode(data));
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

function replaceEmoji(subject) {
	var text = subject['text'];
	if (subject['attachments'] != null) {
		for(i=0; i<subject['attachments'].length; ++i) {
			var attachment = subject['attachments'][i];
			if (attachment['type'] == 'emoji') {
				var pack_id = attachment['charmap'][0][0];
				var powerup_id = attachment['charmap'][0][1];
				var image = null;
				$.each(powerups, function(i, v) {
					if (v['meta']['pack_id'] == pack_id) {
						$.each(v['meta']['inline'], function(j, u) {
							if (u['x'] == 20) {
								image = u['image_url'];
							}
						});
					}
				});
				if (image == null) {
					continue;
				}
				var pixel_down = 20 * powerup_id * -1;
				var image_html = '<span style="';
				image_html += "background: url(";
				image_html += image;
				image_html += ") no-repeat left top;";
				image_html += "background-size: 20px auto !important;";
				image_html += "background-position: 0 ";
				image_html += pixel_down;
				image_html += "px;";
				image_html += '" class="emoji"></span>';
				text = text.replace(attachment['placeholder'], image_html);
			}
		}
	}
	return text;
}

function outputMessage(message){
    if(message['type'] != 'line.create'){
        return;
    }
	text = replaceEmoji(message['subject']);
    var preview = $('.group_preview[data-group-id=' + message['subject']['group_id'] + ']');
    var chat = $('.group_chat[data-group-id=' + message['subject']['group_id'] + ']');
    var preview_content = '<strong>' + message['subject']['name'];
	if ((message['subject']['attachments'] != null)
		&& (message['subject']['attachments'].length > 0)
		&& (message['subject']['attachments'][0]['type'] == 'image')) {
		preview_content += '</strong> posted an image.';
	} else {
		preview_content += ':</strong> ' + text;
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
		if (text != null) {
			content += '<div>' + text + '</div>';
		}
      content +=  '</div>'
      +  '</div>'
      +  '</div>';
		content = replaceEmojiUnicode(content);
		chat.prepend(content);
    }
}
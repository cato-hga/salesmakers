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
});

function outputMessage(message){
    if(message['type'] != 'line.create'){
        return;
    }
    var preview = $('.group_preview[data-group-id=' + message['subject']['group_id'] + ']');
    preview.find('.content').html('<strong>' + message['subject']['name'] + ': </strong>' + message['subject']['text']);
    console.log(JSON.stringify(message));

    preview.prependTo('#chat_aside');
    //console.log(message['subject']['name'] + ': ' + message['subject']['text']);
}

function inputMessage(message_text){

}

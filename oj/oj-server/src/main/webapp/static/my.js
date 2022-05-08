$(function() {
    function setCookie(key, value) {
        document.cookie = key + '=' + value + ';';
    }
    function getCookie(key) {
        var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');
        return keyValue ? keyValue[2] : null;
    }
    function load() {
        if ($('#chat_div').is(':visible')) {
            $('#chat_msg').load('/chat', function() {
                $('#chat_msg p').css({
                    'line-height' : '1.2em'
                });
                $('#chat_msg .user').addClass('text-success').css({
                    'font-weight' : 'bold'
                });
                $('#chat_msg .message').addClass('text-danger');
            });
        }
    }
    $('body')
            .append(
                    $('<div style="position:fixed;bottom:50px;right:13%;width:22%;"><div class="panel panel-default" style="height:250px;background:white;margin-bottom:0;" id="chat_div"><div style="width:100%;height:190px;overflow-y:auto;" id="chat_msg"></div><div><textarea class="form-control" id="send_msg" style="width:100%;"></textarea></div></div><button style="width:20%;" class="btn btn-primary btn-xs" id="send_btn">Send</button><button class="btn btn-xs btn-primary" style="width:80%;" id="chat_btn">Show/Hide chat room</button></div>'));
    if (getCookie('show_chat_room') == 'false') {
        $('#chat_div').hide();
        $('#send_btn').hide();
    } else {
        load();
    }
    setInterval(function() {
        load();
    }, 5000);
    $('#chat_btn').click(function() {
        var div = $('#chat_div');
        var send_btn = $('#send_btn');
        if (div.is(':visible')) {
            send_btn.fadeOut();
            div.fadeOut();
            setCookie('show_chat_room', 'false');
        } else {
            send_btn.fadeIn();
            div.fadeIn();
            load();
            setCookie('show_chat_room', 'true');
        }
    });
    $('#send_msg').focus(function() {
        if ($(this).val() == 'successfully sent!')
            $(this).val('');
    });
    $('#send_btn').click(function() {
        if ($('#send_msg').val().length != 0) {
            $('#send_btn').attr('disabled', 'disabled');
            $.post('/chat', {
                message : $('#send_msg').val()
            }, function(result) {
                $('#send_msg').val(result);
                $('#send_btn').removeAttr('disabled');
            });
        }
    });
});

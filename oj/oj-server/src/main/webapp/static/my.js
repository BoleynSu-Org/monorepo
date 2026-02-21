(function () {
    function setCookie(key, value) {
        document.cookie = key + '=' + value + ';';
    }
    function getCookie(key) {
        var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');
        return keyValue ? keyValue[2] : null;
    }
    function load() {
        var chatDiv = document.getElementById('chat_div');
        if (chatDiv && chatDiv.style.display !== 'none') {
            var chatMsg = document.getElementById('chat_msg');
            var xhr = new XMLHttpRequest();
            xhr.open('GET', '/chat', true);
            xhr.onload = function () {
                if (xhr.status === 200) {
                    chatMsg.innerHTML = xhr.responseText;
                    var paragraphs = chatMsg.querySelectorAll('p');
                    paragraphs.forEach(function (p) {
                        p.style.lineHeight = '1.2em';
                    });
                    var users = chatMsg.querySelectorAll('.user');
                    users.forEach(function (user) {
                        user.classList.add('text-success');
                        user.style.fontWeight = 'bold';
                    });
                    var messages = chatMsg.querySelectorAll('.message');
                    messages.forEach(function (msg) {
                        msg.classList.add('text-danger');
                    });
                }
            };
            xhr.send();
        }
    }
    var chatDiv = document.createElement('div');
    chatDiv.style.position = 'fixed';
    chatDiv.style.bottom = '50px';
    chatDiv.style.right = '13%';
    chatDiv.style.width = '22%';
    chatDiv.innerHTML = '<div class="panel panel-default" style="height:250px;background:white;margin-bottom:0;" id="chat_div"><div style="width:100%;height:190px;overflow-y:auto;" id="chat_msg"></div><div><textarea class="form-control" id="send_msg" style="width:100%;"></textarea></div></div><button style="width:20%;" class="btn btn-primary btn-xs" id="send_btn">Send</button><button class="btn btn-xs btn-primary" style="width:80%;" id="chat_btn">Show/Hide chat room</button>';
    document.body.appendChild(chatDiv);
    var sendBtn = document.getElementById('send_btn');
    var chatBtn = document.getElementById('chat_btn');
    if (getCookie('show_chat_room') != 'true') {
        chatDiv.style.display = 'none';
        sendBtn.style.display = 'none';
    } else {
        load();
    }
    setInterval(function () {
        load();
    }, 5000);
    chatBtn.addEventListener('click', function () {
        if (chatDiv.style.display !== 'none') {
            sendBtn.style.display = 'none';
            chatDiv.style.display = 'none';
            setCookie('show_chat_room', 'false');
        } else {
            sendBtn.style.display = 'inline-block';
            chatDiv.style.display = 'block';
            load();
            setCookie('show_chat_room', 'true');
        }
    });
    var sendMsg = document.getElementById('send_msg');
    sendMsg.addEventListener('focus', function () {
        if (this.value === 'successfully sent!')
            this.value = '';
    });
    sendBtn.addEventListener('click', function () {
        var msg = sendMsg.value;
        if (msg.length !== 0) {
            this.disabled = true;
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '/chat', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function () {
                if (xhr.status === 200) {
                    sendMsg.value = xhr.responseText;
                }
                sendBtn.disabled = false;
            };
            xhr.send('message=' + encodeURIComponent(msg));
        }
    });
})();

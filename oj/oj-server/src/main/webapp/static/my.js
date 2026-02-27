document.addEventListener('DOMContentLoaded', function () {
    function setCookie(key, value) {
        document.cookie = key + '=' + value + ';';
    }

    function getCookie(key) {
        var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');
        return keyValue ? keyValue[2] : null;
    }

    function load() {
        var chatDiv = document.getElementById('chat_div');
        var chatMsg = document.getElementById('chat_msg');
        if (chatDiv && chatDiv.offsetWidth > 0) {
            fetch('/chat')
                .then(response => response.text())
                .then(data => {
                    chatMsg.innerHTML = data;
                    var paragraphs = chatMsg.getElementsByTagName('p');
                    for (var i = 0; i < paragraphs.length; i++) {
                        paragraphs[i].style.lineHeight = '1.2em';
                    }
                    var users = chatMsg.getElementsByClassName('user');
                    for (var i = 0; i < users.length; i++) {
                        users[i].classList.add('text-success');
                        users[i].style.fontWeight = 'bold';
                    }
                    var messages = chatMsg.getElementsByClassName('message');
                    for (var i = 0; i < messages.length; i++) {
                        messages[i].classList.add('text-danger');
                    }
                });
        }
    }

    // Create chat widget
    var chatWidget = document.createElement('div');
    chatWidget.style.position = 'fixed';
    chatWidget.style.bottom = '50px';
    chatWidget.style.right = '13%';
    chatWidget.style.width = '22%';

    var chatDiv = document.createElement('div');
    chatDiv.className = 'panel panel-default';
    chatDiv.style.height = '250px';
    chatDiv.style.backgroundColor = 'white';
    chatDiv.style.marginBottom = '0';
    chatDiv.id = 'chat_div';

    var chatMsg = document.createElement('div');
    chatMsg.style.width = '100%';
    chatMsg.style.height = '190px';
    chatMsg.style.overflowY = 'auto';
    chatMsg.id = 'chat_msg';

    var textarea = document.createElement('textarea');
    textarea.className = 'form-control';
    textarea.id = 'send_msg';
    textarea.style.width = '100%';

    var textareaContainer = document.createElement('div');
    textareaContainer.appendChild(textarea);

    chatDiv.appendChild(chatMsg);
    chatDiv.appendChild(textareaContainer);

    var sendBtn = document.createElement('button');
    sendBtn.style.width = '20%';
    sendBtn.className = 'btn btn-primary btn-xs';
    sendBtn.id = 'send_btn';
    sendBtn.textContent = 'Send';

    var chatBtn = document.createElement('button');
    chatBtn.className = 'btn btn-xs btn-primary';
    chatBtn.style.width = '80%';
    chatBtn.id = 'chat_btn';
    chatBtn.textContent = 'Show/Hide chat room';

    var buttonContainer = document.createElement('div');
    buttonContainer.appendChild(sendBtn);
    buttonContainer.appendChild(chatBtn);

    chatWidget.appendChild(chatDiv);
    chatWidget.appendChild(buttonContainer);

    document.body.appendChild(chatWidget);

    if (getCookie('show_chat_room') != 'true') {
        chatDiv.style.display = 'none';
        sendBtn.style.display = 'none';
    } else {
        load();
    }

    setInterval(load, 5000);

    chatBtn.addEventListener('click', function () {
        var div = chatDiv;
        var sendBtn = document.getElementById('send_btn');
        if (div.offsetWidth > 0) {
            sendBtn.style.opacity = '0';
            div.style.opacity = '0';
            setTimeout(function () {
                sendBtn.style.display = 'none';
                div.style.display = 'none';
                setCookie('show_chat_room', 'false');
            }, 300);
        } else {
            sendBtn.style.display = '';
            div.style.display = '';
            setTimeout(function () {
                sendBtn.style.opacity = '1';
                div.style.opacity = '1';
                load();
                setCookie('show_chat_room', 'true');
            }, 10);
        }
    });

    var sendMsg = document.getElementById('send_msg');
    if (sendMsg) {
        sendMsg.addEventListener('focus', function () {
            if (this.value == 'successfully sent!') {
                this.value = '';
            }
        });
    }

    var sendBtn = document.getElementById('send_btn');
    if (sendBtn) {
        sendBtn.addEventListener('click', function () {
            var input = document.getElementById('send_msg');
            if (input && input.value.length != 0) {
                this.disabled = true;
                fetch('/chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ message: input.value })
                })
                    .then(response => response.text())
                    .then(data => {
                        if (input) {
                            input.value = data.trim();
                        }
                    })
                    .finally(function () {
                        if (this) {
                            this.disabled = false;
                        }
                    }.bind(this));
            }
        });
    }
});

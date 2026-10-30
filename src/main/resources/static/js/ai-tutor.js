// AI Tutor sohbet bileşeni (fragments/ai-tutor.html). Yalnızca ADMIN ve tutor açıkken yüklenir.
//
// Güvenlik sözleşmesi:
// - Kullanıcının mesajı ve sunucunun hata metni YALNIZCA textContent ile basılır.
// - HTML olarak yalnızca yanıtın answerHtml alanı kullanılır. Sunucu onu TutorAnswerRenderer ile
//   temizledi; burada bir kez daha aynı izin listesinden geçirilir (inert bir <template> içinde:
//   betik çalışmaz, görsel yüklenmez). Ham model metni istemciye hiç gelmez.
// - POST/DELETE isteklerine CSRF token'ı <meta name="_csrf"> / <meta name="_csrf_header">'dan
//   başlık olarak eklenir.
// - Hiçbir istek otomatik olarak yeniden gönderilmez; mesaj ya da cevap konsola yazılmaz.
(function () {
    'use strict';

    // Sunucunun beklediği süre (60 sn) + pay. Süre dolarsa istek iptal edilir, tekrar gönderilmez.
    var CLIENT_TIMEOUT_MS = 90000;

    // TutorAnswerRenderer.SAFELIST ile aynı etiket/öznitelik listesi.
    var ALLOWED = {
        P: [], BR: [], HR: [], H3: [], H4: [], H5: [], H6: [], STRONG: [], EM: [],
        CODE: ['class'], PRE: [], BLOCKQUOTE: [], UL: [], OL: ['start'], LI: [], A: ['href', 'rel'],
        TABLE: [], THEAD: [], TBODY: [], TR: [], TH: [], TD: []
    };
    // İçeriğiyle birlikte atılan etiketler; diğer izinsiz etiketlerin yalnızca kendisi atılır.
    var DROP = ['SCRIPT', 'STYLE', 'TEMPLATE', 'IFRAME', 'OBJECT', 'EMBED', 'SVG', 'MATH', 'NOSCRIPT',
        'TEXTAREA', 'SELECT', 'TITLE', 'HEAD'];
    var LINK_REL = 'nofollow noopener noreferrer';
    var CODE_CLASS = /^language-[A-Za-z0-9_+#.-]{1,32}$/;

    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.ai-tutor').forEach(init);
    });

    // Boşluk, kontrol ve görünmez biçim karakterleri: tarayıcı onları adresten silip örneğin
    // "java\tscript:" değerini yeniden "javascript:" yapabilir (Java tarafındaki kuralla aynı).
    function isUnsafeUrlChar(code) {
        return code <= 0x20 || (code >= 0x7f && code <= 0xa0) || code === 0xad || code === 0x1680
            || (code >= 0x2000 && code <= 0x200f) || (code >= 0x2028 && code <= 0x202f)
            || (code >= 0x205f && code <= 0x2064) || code === 0x3000 || code === 0xfeff;
    }

    // TutorAnswerRenderer.isAllowedHref ile aynı kural.
    function isAllowedHref(href) {
        if (!href) {
            return false;
        }
        for (var i = 0; i < href.length; i++) {
            if (isUnsafeUrlChar(href.charCodeAt(i))) {
                return false;
            }
        }
        if (href.charAt(0) === '#') {
            return true;
        }
        if (href.charAt(0) === '/') {
            return href.length === 1 || (href.charAt(1) !== '/' && href.charAt(1) !== '\\');
        }
        return /^https?:\/\/[^/\\]/i.test(href);
    }

    function cleanChildren(parent) {
        Array.prototype.slice.call(parent.childNodes).forEach(function (node) {
            if (node.nodeType === Node.TEXT_NODE) {
                return;
            }
            if (node.nodeType !== Node.ELEMENT_NODE) {
                node.remove();
                return;
            }
            var tag = node.tagName.toUpperCase();
            var allowedAttributes = ALLOWED[tag];
            if (!allowedAttributes) {
                if (DROP.indexOf(tag) >= 0) {
                    node.remove();
                } else {
                    unwrap(node);
                }
                return;
            }
            Array.prototype.slice.call(node.attributes).forEach(function (attribute) {
                if (allowedAttributes.indexOf(attribute.name.toLowerCase()) < 0) {
                    node.removeAttribute(attribute.name);
                }
            });
            if (tag === 'A') {
                if (!isAllowedHref(node.getAttribute('href'))) {
                    unwrap(node);
                    return;
                }
                node.setAttribute('rel', LINK_REL);
            }
            if (tag === 'CODE' && node.hasAttribute('class') && !CODE_CLASS.test(node.getAttribute('class'))) {
                node.removeAttribute('class');
            }
            if (tag === 'OL' && node.hasAttribute('start') && !/^\d{1,9}$/.test(node.getAttribute('start'))) {
                node.removeAttribute('start');
            }
            cleanChildren(node);
        });
    }

    // Etiketin kendisini atar, (temizlenmiş) çocuklarını yerinde bırakır.
    function unwrap(node) {
        cleanChildren(node);
        var parent = node.parentNode;
        while (node.firstChild) {
            parent.insertBefore(node.firstChild, node);
        }
        node.remove();
    }

    function safeAnswerFragment(answerHtml) {
        var template = document.createElement('template');
        template.innerHTML = answerHtml;
        cleanChildren(template.content);
        return template.content;
    }

    function format(template, value) {
        return template.replace('{0}', String(value));
    }

    function init(root) {
        var data = root.dataset;
        var list = root.querySelector('.ai-tutor-messages');
        var emptyText = root.querySelector('.ai-tutor-empty');
        var alertBox = root.querySelector('.ai-tutor-alert');
        var note = root.querySelector('.ai-tutor-note');
        var form = root.querySelector('.ai-tutor-form');
        var input = root.querySelector('.ai-tutor-input');
        var sendButton = root.querySelector('.ai-tutor-send');
        var spinner = root.querySelector('.ai-tutor-spinner');
        var newButton = root.querySelector('.ai-tutor-new');
        var deleteButton = root.querySelector('.ai-tutor-delete');
        var status = root.querySelector('.ai-tutor-status');

        var state = {
            conversationId: null,
            // Bir istek sürerken ikinci bir istek gönderilmez (sunucu da tek isteğe izin verir).
            busy: false,
            // Konuşma kaydedilemedi/kayboldu ya da oturum düştü: kullanıcı yeni konuşma başlatana
            // kadar soru gönderilmez -- eski konuşmaya devam ediliyormuş gibi davranılmaz.
            locked: false
        };

        function csrfHeaders() {
            var token = document.querySelector('meta[name="_csrf"]');
            var header = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (token && header) {
                headers[header.getAttribute('content')] = token.getAttribute('content');
            }
            return headers;
        }

        function refreshControls() {
            sendButton.disabled = state.busy || state.locked;
            input.readOnly = state.busy || state.locked;
            newButton.disabled = state.busy;
            deleteButton.disabled = state.busy || state.conversationId === null;
            spinner.classList.toggle('d-none', !state.busy);
            list.setAttribute('aria-busy', state.busy ? 'true' : 'false');
            status.textContent = state.busy ? status.dataset.busyText : '';
        }

        function showAlert(text) {
            alertBox.textContent = text;
            alertBox.classList.remove('d-none');
        }

        function clearAlert() {
            alertBox.textContent = '';
            alertBox.classList.add('d-none');
        }

        function showNote(text) {
            note.textContent = text || '';
            note.classList.toggle('d-none', !text);
        }

        function scrollToEnd() {
            list.scrollTop = list.scrollHeight;
        }

        function appendMessage(kind, roleLabel) {
            if (emptyText) {
                emptyText.classList.add('d-none');
            }
            var item = document.createElement('div');
            item.className = 'ai-tutor-message ai-tutor-message-' + kind;
            var role = document.createElement('div');
            role.className = 'ai-tutor-role';
            role.textContent = roleLabel;
            item.appendChild(role);
            list.appendChild(item);
            return item;
        }

        function addUserMessage(text) {
            var item = appendMessage('user', data.msgYou);
            var body = document.createElement('div');
            body.className = 'ai-tutor-text';
            body.textContent = text;
            item.appendChild(body);
            scrollToEnd();
            return item;
        }

        function addInlineNotice(item, text, className) {
            var notice = document.createElement('div');
            notice.className = 'small mt-2 ' + className;
            notice.textContent = text;
            item.appendChild(notice);
        }

        function addAnswer(response) {
            var item = appendMessage('tutor', data.msgTutor);
            var body = document.createElement('div');
            body.className = 'ai-tutor-answer';
            body.appendChild(safeAnswerFragment(response.answerHtml));
            item.appendChild(body);
            if (window.hljs) {
                body.querySelectorAll('pre code').forEach(function (block) {
                    window.hljs.highlightElement(block);
                });
            }
            if (response.truncated === true) {
                addInlineNotice(item, data.msgTruncated, 'text-body-secondary');
            }
            if (response.conversationSaved !== true) {
                addInlineNotice(item, data.msgNotSaved, 'alert alert-warning mb-0 py-2');
            }
            scrollToEnd();
        }

        function resetConversation() {
            state.conversationId = null;
            state.locked = false;
            list.querySelectorAll('.ai-tutor-message').forEach(function (item) {
                item.remove();
            });
            if (emptyText) {
                emptyText.classList.remove('d-none');
            }
            clearAlert();
            showNote('');
        }

        function lockConversation(message) {
            state.conversationId = null;
            state.locked = true;
            showAlert(message);
        }

        function isAnswer(body) {
            return body !== null && typeof body === 'object' && typeof body.answerHtml === 'string'
                && typeof body.conversationSaved === 'boolean';
        }

        function readJson(response) {
            var type = response.headers.get('Content-Type') || '';
            if (type.indexOf('application/json') < 0) {
                return Promise.resolve(null);
            }
            return response.json().catch(function () {
                return null;
            });
        }

        // Yalnızca AiTutorController'ın {error: "kod", message: "..."} gövdesi. Spring'in kendi hata
        // gövdeleri (ör. CSRF reddinde {"error": "Forbidden", ...}) bu biçimde değildir ve kullanılmaz.
        function isTutorError(body) {
            return body !== null && typeof body === 'object' && typeof body.error === 'string'
                && /^[a-z_]{1,40}$/.test(body.error) && typeof body.message === 'string' && body.message !== '';
        }

        // Sunucunun yerelleştirilmiş metni varsa o; yoksa durum koduna göre kendi metnimiz. Teknik
        // ayrıntı hiçbir zaman gösterilmez.
        function errorMessage(statusCode, body) {
            if (isTutorError(body)) {
                return body.message;
            }
            if (statusCode === 401) {
                return data.msgSessionExpired;
            }
            if (statusCode === 403) {
                return data.msgNotAllowed;
            }
            return data.msgGeneric;
        }

        function handleError(statusCode, body) {
            var code = isTutorError(body) ? body.error : null;
            var message = errorMessage(statusCode, body);
            if (code === 'conversation_not_found') {
                lockConversation(message);
            } else if (statusCode === 401 || code === 'not_authenticated') {
                lockConversation(message);
            } else {
                showAlert(message);
            }
        }

        function markUnanswered(userItem, text) {
            addInlineNotice(userItem, data.msgUnanswered, 'text-body-secondary');
            // Kullanıcı isterse KENDİSİ yeniden gönderebilsin diye metin geri konur; otomatik gönderim yok.
            if (!input.value) {
                input.value = text;
            }
        }

        function send() {
            var text = input.value;
            if (state.busy || state.locked || !text.trim()) {
                return;
            }
            clearAlert();
            showNote('');
            var userItem = addUserMessage(text);
            input.value = '';
            state.busy = true;
            refreshControls();

            var controller = new AbortController();
            var timer = setTimeout(function () {
                controller.abort();
            }, CLIENT_TIMEOUT_MS);
            var headers = csrfHeaders();
            headers['Content-Type'] = 'application/json';
            headers['Accept'] = 'application/json';

            fetch(data.messagesUrl, {
                method: 'POST',
                credentials: 'same-origin',
                headers: headers,
                body: JSON.stringify({
                    conversationId: state.conversationId,
                    message: text,
                    topicSlug: data.topicSlug || null
                }),
                signal: controller.signal
            }).then(function (response) {
                return readJson(response).then(function (body) {
                    if (response.ok && isAnswer(body)) {
                        addAnswer(body);
                        if (body.conversationSaved === true && typeof body.conversationId === 'string') {
                            state.conversationId = body.conversationId;
                            showNote(body.turnsRemaining > 0
                                ? format(data.msgTurnsRemaining, body.turnsRemaining)
                                : data.msgTurnsExhausted);
                        } else {
                            // Cevap gösterildi ama hiçbir konuşmada değil: yeni konuşma başlatılmadan
                            // ikinci soru gönderilmez.
                            lockConversation(data.msgNotSaved);
                        }
                        return;
                    }
                    markUnanswered(userItem, text);
                    handleError(response.ok ? 0 : response.status, response.ok ? null : body);
                });
            }).catch(function (error) {
                markUnanswered(userItem, text);
                showAlert(error && error.name === 'AbortError' ? data.msgClientTimeout : data.msgNetwork);
            }).finally(function () {
                clearTimeout(timer);
                state.busy = false;
                refreshControls();
                if (!state.locked) {
                    input.focus();
                }
            });
        }

        function deleteConversation() {
            var id = state.conversationId;
            if (state.busy || id === null) {
                return;
            }
            clearAlert();
            state.busy = true;
            refreshControls();
            fetch(data.conversationsUrl + '/' + encodeURIComponent(id), {
                method: 'DELETE',
                credentials: 'same-origin',
                headers: csrfHeaders()
            }).then(function (response) {
                if (response.status === 204 || response.status === 404) {
                    // 404: konuşma zaten yok; ikisinde de ekrandaki konuşma kapanır.
                    resetConversation();
                    showNote(data.msgDeleted);
                    return;
                }
                return readJson(response).then(function (body) {
                    handleError(response.status, body);
                });
            }).catch(function () {
                showAlert(data.msgNetwork);
            }).finally(function () {
                state.busy = false;
                refreshControls();
            });
        }

        form.addEventListener('submit', function (event) {
            event.preventDefault();
            send();
        });

        input.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' && !event.shiftKey && !event.isComposing) {
                event.preventDefault();
                send();
            }
        });

        newButton.addEventListener('click', function () {
            if (state.busy) {
                return;
            }
            resetConversation();
            refreshControls();
            input.focus();
        });

        deleteButton.addEventListener('click', deleteConversation);

        refreshControls();
    }
})();

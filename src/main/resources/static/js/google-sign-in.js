// "Google ile devam et" butonunun yükleniyor durumu (fragments/google-sign-in.html).
// Buton düz bir bağlantı; burada yalnızca tıklandıktan sonra ikinci bir tıklamayı
// engelleyip "Google'a yönlendiriliyor…" gösteriliyor. Kullanıcı Google'dan geri tuşuyla
// dönerse (sayfa bfcache'ten gelir) buton eski haline döner.
(function () {
    'use strict';

    var button = document.querySelector('[data-google-sign-in]');
    if (!button) {
        return;
    }

    var label = button.querySelector('[data-google-sign-in-label]');
    var spinner = button.querySelector('.spinner-border');
    var logo = button.querySelector('.btn-google-logo');
    var originalLabel = label.textContent;

    function setLoading(loading) {
        button.classList.toggle('disabled', loading);
        button.setAttribute('aria-disabled', loading ? 'true' : 'false');
        button.setAttribute('aria-busy', loading ? 'true' : 'false');
        spinner.classList.toggle('d-none', !loading);
        logo.classList.toggle('d-none', loading);
        label.textContent = loading ? button.getAttribute('data-loading-text') : originalLabel;
    }

    button.addEventListener('click', function (event) {
        if (button.classList.contains('disabled')) {
            event.preventDefault();
            return;
        }
        setLoading(true);
    });

    window.addEventListener('pageshow', function (event) {
        if (event.persisted) {
            setLoading(false);
        }
    });
})();

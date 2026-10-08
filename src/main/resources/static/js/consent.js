// Çerez onayı. Banner (fragments/layout.html :: footer) yalnızca özellik açıkken sayfada
// bulunur; yoksa bu dosya hiç yüklenmez. Tercih sunucuya gönderilmez, tarayıcıda
// localStorage'da tutulur: { version, choice: 'accepted' | 'rejected', date }.
(function () {
    'use strict';

    var STORAGE_KEY = 'lfx-consent';
    // Onayın kapsamı değişirse (örn. yeni bir çerez kategorisi) artırılır: eski kayıt
    // geçersiz sayılır ve tercih yeniden sorulur.
    var CONSENT_VERSION = 1;

    var banner = document.getElementById('cookie-consent');
    if (!banner) {
        return;
    }

    var settings = banner.querySelector('[data-consent-settings]');
    var analyticsToggle = banner.querySelector('[data-consent-analytics]');
    var settingsButton = banner.querySelector('[data-consent-action="settings"]');
    var saveButton = banner.querySelector('[data-consent-action="save"]');

    function readConsent() {
        try {
            var state = JSON.parse(window.localStorage.getItem(STORAGE_KEY));
            if (state && state.version === CONSENT_VERSION
                    && (state.choice === 'accepted' || state.choice === 'rejected')) {
                return state;
            }
        } catch (e) {
            // localStorage kapalı ya da kayıt bozuk: tercih yok sayılır.
        }
        return null;
    }

    function storeConsent(choice) {
        var state = {version: CONSENT_VERSION, choice: choice, date: new Date().toISOString()};
        try {
            window.localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
        } catch (e) {
            // Saklanamazsa tercih yalnızca bu sayfa için geçerli olur.
        }
        return state;
    }

    // Analitik için genişleme noktası. Şu an hiçbir analitik hizmeti yok, bu yüzden boş:
    // onay verilse bile hiçbir script yüklenmez, hiçbir çerez yazılmaz.
    function enableAnalytics() {
    }

    function applyConsent(state) {
        if (state && state.choice === 'accepted') {
            enableAnalytics();
        }
    }

    function showSettings(visible) {
        settings.hidden = !visible;
        saveButton.hidden = !visible;
        settingsButton.hidden = visible;
    }

    function openBanner(withSettings) {
        var state = readConsent();
        analyticsToggle.checked = !!state && state.choice === 'accepted';
        showSettings(withSettings);
        banner.hidden = false;
    }

    function choose(choice) {
        banner.hidden = true;
        applyConsent(storeConsent(choice));
    }

    document.addEventListener('click', function (event) {
        if (event.target.closest('[data-consent-open]')) {
            openBanner(true);
            banner.focus();
            return;
        }
        var button = event.target.closest('[data-consent-action]');
        if (!button || !banner.contains(button)) {
            return;
        }
        var action = button.getAttribute('data-consent-action');
        if (action === 'settings') {
            showSettings(true);
        } else if (action === 'accept') {
            choose('accepted');
        } else if (action === 'reject') {
            choose('rejected');
        } else if (action === 'save') {
            choose(analyticsToggle.checked ? 'accepted' : 'rejected');
        }
    });

    var stored = readConsent();
    if (stored) {
        applyConsent(stored);
    } else {
        openBanner(false);
    }
})();

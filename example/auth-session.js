var Safari = require('ti.safaridialog');

var authSession = Safari.createAuthenticationSession({
    url: 'https://example.com/oauth',
    scheme: 'myapp',
    callback: function(e) {
        if (!e.success) {
            Ti.API.error('Error authenticating: ' + e.error);
            return;
        }
        
        Ti.API.info('Callback URL: ' + e.callbackURL);
    }
});

var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var btn = Ti.UI.createButton({
    title: 'Start OAuth-session'
});

btn.addEventListener('click', function() {
    authSession.start(); // Or cancel() to cancel it manually.
});

win.add(btn);
win.open();

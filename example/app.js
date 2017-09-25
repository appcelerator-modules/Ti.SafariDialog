var Safari = require('ti.safaridialog');

var win = Titanium.UI.createWindow({
  title: 'Ti.SafariDialog Demo',
  backgroundColor: '#fff'
});

var nav = Ti.UI.iOS.createNavigationWindow({
  window: win
})

var btnOpenDialog = Ti.UI.createButton({
  title: 'Open Safari Dialog'
});
win.add(btnOpenDialog);

btnOpenDialog.addEventListener('click', function(d) {
  Safari.open({
    url: 'http://appcelerator.com',
    title: 'Hello World',
    
    // iOS 10+
    tintColor: 'red',
    barColor: 'green',

    // iOS 11+
    barCollapsingEnabled: false,
    dismissButtonStyle: Safari.DISMISS_BUTTON_STYLE_CLOSE
  });
});

Safari.addEventListener('open', function(e) {
  console.log('open: ' + JSON.stringify(e));
});

Safari.addEventListener('close', function(e) {
  console.log('close: ' + JSON.stringify(e));
});

nav.open();

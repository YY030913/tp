Package.describe({
  summary: "Update the client when new client code is available",
  version: '1.2.4'
});

Cordova.depends({
  'cordova-plugin-file': '2.1.0',
  'cordova-plugin-file-transfer': '1.2.0'
});

Package.onUse(function (api) {
  api.use('ecmascript');
  api.use([
    'webapp@1.2.3',
    'check@1.1.0'
  ], 'server');

  api.use([
    'tracker@1.0.9',
    'retry@1.0.4'
  ], 'client');

  api.use([
    'ddp@1.2.2',
    'mongo@1.1.3',
    'underscore@1.0.4'
  ], ['client', 'server']);

  api.use(['http@1.1.1', 'random@1.0.5'], 'web.cordova');

  api.addFiles('autoupdate_server.js', 'server');
  api.addFiles('autoupdate_client.js', 'web.browser');
  api.addFiles('autoupdate_cordova.js', 'web.cordova');

  api.export('Autoupdate');
});

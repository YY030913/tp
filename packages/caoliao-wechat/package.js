Package.describe({
  name: 'caoliao:wechat',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Npm.depends({
  "buffer": "4.7.0",
  "sha1": "1.0.1",
  "xml2js": "0.2.6"
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');
  api.use([
    'ecmascript',
    'coffeescript@1.0.11',
    'caoliao:lib',
    'caoliao:api',
    'nimble:restivus@0.8.10'
  ]);
  api.use('ecmascript');
  api.addFiles('wechat.js', 'server');
  api.addFiles('server/api.coffee', 'server');

  api.export('Weixin', 'server');
});
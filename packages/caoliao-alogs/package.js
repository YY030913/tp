Package.describe({
  name: 'caoliao:alogs',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

// Npm.depends({
//     'alogs':'0.1.5'
// });

Package.onUse(function(api) {
  api.versionsFrom('1.4.0.1');
  api.use('ecmascript');
  // api.use(['cosmos:browserify@0.9.3'], 'client');

  // api.addFiles([
  //   'app.browserify.js'
  // ], 'client');

  // api.exports('alogs');

  api.addFiles('alog.js', 'client');
});

Package.describe({
  name: 'caoliao:qrcode',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.4.1');
  api.use('jquery@1.11.4');
  api.use('ecmascript');
  api.addFiles('qrcode.js', 'client');
});

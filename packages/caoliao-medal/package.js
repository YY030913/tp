Package.describe({
  name: 'caoliao:medal',
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
  api.versionsFrom('1.2.1');
  api.use('reactive-var@1.0.6');
  api.use('tracker@1.0.9');
  api.use('underscore@1.0.4');
  api.use('templating@1.1.5', 'client');
  api.use('kadira:flow-router@2.10.1', 'client');
  api.use([
    'ecmascript',
    'jquery@1.11.4',
    'caoliao:lib',
    'caoliao:ui']);
  api.use('coffeescript@1.0.11');


  api.addFiles('server/startup.coffee', 'server');
  api.addFiles('server/models/base.js', 'server');
  api.addFiles('server/models/medals.coffee', 'server');
  
  api.addFiles('client/router.coffee', 'client');

  api.addFiles('client/views/medalRole.html', 'client');
  api.addFiles('client/views/medals.html', 'client');
  
  api.addFiles('client/views/medalRole.coffee', 'client');
  api.addFiles('client/views/medals.coffee', 'client');
});
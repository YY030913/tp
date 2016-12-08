Package.describe({
  name: 'caoliao:ui-pk',
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
  api.use('reactive-var@1.0.6');
  api.use('tracker@1.0.9');
  api.use('templating@1.1.5', 'client');
  api.use('kadira:flow-router@2.10.1', 'client');

  api.use([
    'ecmascript',
    'coffeescript@1.0.11',
    'underscore@1.0.4',
    'caoliao:lib',
    'jquery@1.11.4',
    'caoliao:api',
    'caoliao:bosonnlp',
    // 'caoliao:parallaxscrollview',
    'caoliao:swiper',
    'caoliao:keyboardawarelistview',
    'caoliao:wangeditor',
    'caoliao:ui',
    'caoliao:ui-activity',
    // 'caoliao:ui-user',
    'nimble:restivus@0.8.10',
    'percolate:synced-cron',
    // 'caoliao:summary',
    'caoliao:ui-activity',
    'caoliao:score',
    // 'caoliao:react-native-swipeout',
    'sha@1.0.4'
  ]);

  api.addFiles('client/views/pk.html', 'client');
  
  api.addFiles('client/views/pk.coffee', 'client');
  
});
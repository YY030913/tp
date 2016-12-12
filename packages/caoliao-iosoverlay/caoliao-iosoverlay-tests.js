// Import Tinytest from the tinytest Meteor package.
import { Tinytest } from "meteor/tinytest";

// Import and rename a variable exported by caoliao-iosoverlay.js.
import { name as packageName } from "meteor/caoliao-iosoverlay";

// Write your tests here!
// Here is an example.
Tinytest.add('caoliao-iosoverlay - example', function (test) {
  test.equal(packageName, "caoliao-iosoverlay");
});

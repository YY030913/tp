// Import Tinytest from the tinytest Meteor package.
import { Tinytest } from "meteor/tinytest";

// Import and rename a variable exported by caoliao-ui-user.js.
import { name as packageName } from "meteor/caoliao-ui-user";

// Write your tests here!
// Here is an example.
Tinytest.add('caoliao-ui-user - example', function (test) {
  test.equal(packageName, "caoliao-ui-user");
});

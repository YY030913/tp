Meteor.publish('permissions', function() {
	return CaoLiao.models.Permissions.find({});
});

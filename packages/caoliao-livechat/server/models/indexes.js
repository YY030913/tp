Meteor.startup(function() {
	CaoLiao.models.Rooms.tryEnsureIndex({ code: 1 });
	CaoLiao.models.Rooms.tryEnsureIndex({ open: 1 }, { sparse: 1 });
});

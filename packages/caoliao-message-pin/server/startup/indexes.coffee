Meteor.startup ->
	Meteor.defer ->
		CaoLiao.models.Messages.tryEnsureIndex { 'pinnedBy._id': 1 }, { sparse: 1 }

Meteor.startup ->
	Meteor.defer ->
		CaoLiao.models.Messages.tryEnsureIndex { 'starred._id': 1 }, { sparse: 1 }

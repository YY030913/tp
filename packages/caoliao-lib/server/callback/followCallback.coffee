Meteor.startup ->
	afterAddFollowCallback = (follow) ->
		Tracker.nonreactive ->
			user = Meteor.user()
			content = "#{follow.u.name} #{TAPi18n.__("Follow", { lng: user?.language || CaoLiao.settings.get('language') || 'en' })} #{follow.friend.name}"
			activity = CaoLiao.Activity.utils.add(TAPi18n.__("Follow", { lng: user?.language || CaoLiao.settings.get('language') || 'en' }), content, 'add_follow', 'Add_Follow')
			activity.userId = Meteor.userId()
			CaoLiao.models.Activity.createActivity(activity)
			# score = CaoLiao.Score.utils.addDebate(debate, 'create_debate', 'Create_Debae')
			# CaoLiao.models.Score.update(Meteor.userId(), score, CaoLiao.Score.utils.debateCreateScore)

	CaoLiao.callbacks.add 'afterAddFollow', afterAddFollowCallback, CaoLiao.callbacks.priority.HIGH

	afterCancelFollowCallback = (follow) ->
		Tracker.nonreactive ->
			user = Meteor.user()
			content = "#{follow.u.name} #{TAPi18n.__('Cancel_Follow', { lng: user?.language || CaoLiao.settings.get('language') || 'en' })} #{follow.friend.name}"
			activity = CaoLiao.Activity.utils.add(TAPi18n.__("Cancel_Follow", { lng: user?.language || CaoLiao.settings.get('language') || 'en' }), content, 'cancel_follow', 'Cancel_Follow')
			
			activity.userId = Meteor.userId()
			CaoLiao.models.Activity.createActivity(activity)
			# score = CaoLiao.Score.utils.addDebate(debate, 'create_debate', 'Create_Debae')
			# CaoLiao.models.Score.update(Meteor.userId(), score, CaoLiao.Score.utils.debateCreateScore)

	CaoLiao.callbacks.add 'afterCancelFollow', afterCancelFollowCallback, CaoLiao.callbacks.priority.HIGH

Meteor.startup ->
	beforeCreateDebateCallback = (debate) ->
		Tracker.nonreactive ->
			if debate?.htmlBody?
				debate.htmlBody = CaoLiao.utils.extendRemoveImgSrcs debate.htmlBody
				# debate.imgs = CaoLiao.utils.stripImgSrcs debate.htmlBody
				debate.txt = CaoLiao.utils.stripHTML debate.htmlBody

				###
				SummaryTool.summarize '', debate.txt, (err, summary)->
					debate.summary = summary
				###

		return debate

	CaoLiao.callbacks.add 'beforeCreateDebate', beforeCreateDebateCallback, CaoLiao.callbacks.priority.HIGH

	afterCreateDebateCallback = (debate) ->
		Tracker.nonreactive ->
			if debate?.htmlBody?
				CaoLiao.models.DebateHistories.createDebate(debate)

				if CaoLiao.models.Activity.find({userId: Meteor.userId(), "operator": "create_debate", href: "/debate/#{debate._id}"}).count() > 0
					
					if debate.save
						activity = CaoLiao.Activity.utils.add(debate.name, debate.abstracttml, 'update_debate', 'Update_Debae', "/debate/#{debate._id}")
						
					
						activity.userId = Meteor.userId()
						CaoLiao.models.Activity.createActivity(activity)
				else
					if debate.save
						
						activity = CaoLiao.Activity.utils.add(debate.name, debate.abstracttml, 'create_debate', 'Create_Debae', "/debate/#{debate._id}")
						
						activity.userId = Meteor.userId()
						CaoLiao.models.Activity.createActivity(activity)

						score = CaoLiao.Score.utils.add("/debate/#{debate._id}", 'create_debate', 'Create_Debae')
						score.userId = Meteor.userId()
						score.score = CaoLiao.Score.utils.debateCreateScore
						CaoLiao.models.Score.create(score)
		if debate.save?
			_.each(debate.tags, (element, index, list)->
				CaoLiao.models.DebateSubscriptions.incUnreadForTagIdExcludingUserId(element._id, Meteor.userId());
			)
			
		return debate

	CaoLiao.callbacks.add 'afterCreateDebate', afterCreateDebateCallback, CaoLiao.callbacks.priority.HIGH

Meteor.startup ->
	beforeCreateScoreCallback = (score) ->
		Tracker.nonreactive ->
			if score?.htmlBody?
				score.imgs = CaoLiao.utils.stripImgSrcs score.htmlBody
				score.txt = CaoLiao.utils.stripHTML score.htmlBody

		return score

	CaoLiao.callbacks.add 'beforeCreateScore', beforeCreateScoreCallback, CaoLiao.callbacks.priority.HIGH

	afterCreateScoreCallback = (score) ->
		Tracker.nonreactive ->
			if score?.htmlBody?
				CaoLiao.models.ScoreHistories.insert(score)
		return score

	CaoLiao.callbacks.add 'afterCreateScore', afterCreateScoreCallback, CaoLiao.callbacks.priority.HIGH

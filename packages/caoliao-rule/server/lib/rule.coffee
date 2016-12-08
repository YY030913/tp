CaoLiao.rule = {}

CaoLiao.rule.allow = (userId) ->
	if not userId
		return false

	user = CaoLiao.models.Users.findOneById(userId)
	if not user
		throw new Meteor.Error 'invalid-user'

	score = CaoLiao.models.Score.findByUserId(userId)
	if score.score < CaoLiao.Score.utils.minScore
		return false

	return true


CaoLiao.rule.allowCreateDebate = (userId) ->
	if not userId
		return false

	user = CaoLiao.models.Users.findOneById(userId)
	if not user
		throw new Meteor.Error 'invalid-user'

	score = CaoLiao.models.Score.findByUserId(userId)
	if score.score < CaoLiao.Score.utils.minScore
		return false

	now = new Date()
	today = new Date(now.getgetYear(), now.getMonth(), now.getDate())
	if CaoLiao.Score.utils.canCreateDebateCount(score.score) > CaoLiao.models.Debates.findList({"user.userId": userId, ts: {$gt: today}})
		return true
	return false

CaoLiao.rule.allowCreateDebate = (userId, debateType) ->
	if not userId
		return false

	user = CaoLiao.models.Users.findOneById(userId)
	if not user
		throw new Meteor.Error 'invalid-user'

	tag = Tag.findOneByNameAndType(debateType, 'o')
	if not tag
		throw new Meteor.Error 'invalid-debateType'

	canCreate = false
	_.each(tag.showOnSelectType, (element, index, list)->
		if _.indexOf(Meteor.user().roles, element) > -1
			canCreate = true
	)
	if !canCreate
		throw new Meteor.Error 'user-not-allow-for-the-debateType'
	else
		score = CaoLiao.models.Score.findByUserId(userId)
		if score.score < CaoLiao.Score.utils.minScore
			return false

		now = new Date()
		today = new Date(now.getgetYear(), now.getMonth(), now.getDate())
		if CaoLiao.Score.utils.canCreateDebateCount(score.score) > CaoLiao.models.Debates.findList({"user.userId": userId, ts: {$gt: today}})
			return true
		return false
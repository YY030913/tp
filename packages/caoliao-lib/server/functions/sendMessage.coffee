CaoLiao.sendMessage = (user, message, room) ->
	if not user or not message or not room._id
		return false

	unless message.ts?
		message.ts = new Date()

	message.u = _.pick user, ['_id','username']

	message.rid = room._id

	if not room.usernames?
		room = CaoLiao.models.Rooms.findOneById(room._id)

	if message.parseUrls isnt false
		if urls = message.msg.match /([A-Za-z]{3,9}):\/\/([-;:&=\+\$,\w]+@{1})?([-A-Za-z0-9\.]+)+:?(\d+)?((\/[-\+=!:~%\/\.@\,\w]*)?\??([-\+=&!:;%@\/\.\,\w]+)?(?:#([^\s\)]+))?)?/g
			message.urls = urls.map (url) -> url: url

	message = CaoLiao.callbacks.run 'beforeSaveMessage', message

	if message._id?
		_id = message._id
		delete message._id
		CaoLiao.models.Messages.upsert {_id: _id, 'u._id': message.u._id}, message
		message._id = _id
	else
		message._id = CaoLiao.models.Messages.insert message

	###
	Defer other updates as their return is not interesting to the user
	###
	Meteor.defer ->
		# Execute all callbacks

		activity = CaoLiao.Activity.utils.add(room.name, message.msg, 'send_message', 'Send_Message')
		activity.userId = user._id
		activity.hidden = true
		CaoLiao.models.Activity.createActivity(activity)

		score = CaoLiao.Score.utils.add("", 'send_message', 'Send_Message')
		score.userId = user._id
		score.score = CaoLiao.Score.utils.sendMessage
		CaoLiao.models.Score.create(score)
	

		CaoLiao.callbacks.run 'afterSaveMessage', message, room

	return message

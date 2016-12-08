###
# Kick is a named function that will replace /kick commands
###

class Kick
	constructor: (command, params, item) ->
		if command isnt 'kick' or not Match.test params, String
			return

		username = params.trim()
		if username is ''
			return

		username = username.replace('@', '')

		user = Meteor.users.findOne Meteor.userId()
		kickedUser = CaoLiao.models.Users.findOneByUsername username
		room = CaoLiao.models.Rooms.findOneById item.rid

		if not kickedUser?
			CaoLiao.Notifications.notifyUser Meteor.userId(), 'message', {
				_id: Random.id()
				rid: item.rid
				ts: new Date
				msg: TAPi18n.__('Username_doesnt_exist', { postProcess: 'sprintf', sprintf: [ username ] }, user.language);
			}
			return

		if username not in (room.usernames or [])
			CaoLiao.Notifications.notifyUser Meteor.userId(), 'message', {
				_id: Random.id()
				rid: item.rid
				ts: new Date
				msg: TAPi18n.__('Username_is_not_in_this_room', { postProcess: 'sprintf', sprintf: [ username ] }, user.language);
			}
			return

		Meteor.call 'removeUserFromRoom', { rid: item.rid, username: username }

CaoLiao.slashCommands.add 'kick', Kick

###
# Leave is a named function that will replace /leave commands
# @param {Object} message - The message object
###

if Meteor.isClient
	CaoLiao.slashCommands.add 'leave', undefined,
		description: 'Leave the current channel'
		params: ''

	CaoLiao.slashCommands.add 'part', undefined,
		description: 'Leave the current channel'
		params: ''
else
	class Leave
		constructor: (command, params, item) ->
			if(command == "leave" || command == "part")
				try
					Meteor.call 'leaveRoom', item.rid
				catch err
					CaoLiao.Notifications.notifyUser Meteor.userId(), 'message', {
						_id: Random.id()
						rid: item.rid
						ts: new Date
						msg: TAPi18n.__(err.error, null, Meteor.user().language)
					}

	CaoLiao.slashCommands.add 'leave', Leave
	CaoLiao.slashCommands.add 'part', Leave

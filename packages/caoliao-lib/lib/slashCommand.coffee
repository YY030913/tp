CaoLiao.slashCommands =
	commands: {}

CaoLiao.slashCommands.add = (command, callback, options) ->
	CaoLiao.slashCommands.commands[command] =
		command: command
		callback: callback
		params: options?.params
		description: options?.description

	return

CaoLiao.slashCommands.run = (command, params, item) ->
	if CaoLiao.slashCommands.commands[command]?.callback?
		callback = CaoLiao.slashCommands.commands[command].callback
		callback command, params, item


Meteor.methods
	slashCommand: (command) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'slashCommand' }

		CaoLiao.slashCommands.run command.cmd, command.params, command.msg


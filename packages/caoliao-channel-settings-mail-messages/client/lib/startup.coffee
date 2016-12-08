Meteor.startup ->
	CaoLiao.ChannelSettings.addOption
		id: 'mail-messages'
		template: 'channelSettingsMailMessages'
		validation: ->
			return CaoLiao.authz.hasAllPermission('mail-messages')

	CaoLiao.callbacks.add 'roomExit', (mainNode) ->
		messagesBox = $('.messages-box')
		if messagesBox.get(0)?
			instance = Blaze.getView(messagesBox.get(0))?.templateInstance()
			instance?.resetSelection(false)
	, CaoLiao.callbacks.priority.MEDIUM, 'room-exit-mail-messages'

CaoLiao.Message =
	parse: (msg, language) ->
		messageType = CaoLiao.MessageTypes.getType(msg)
		if messageType?.render?
			return messageType.render(msg)
		else if messageType?.template?
			# render template
		else if messageType?.message?
			if not language and localStorage?.getItem('userLanguage')
				language = localStorage.getItem('userLanguage')
			if messageType.data?(msg)?
				return TAPi18n.__(messageType.message, messageType.data(msg), language)
			else
				return TAPi18n.__(messageType.message, {}, language)
		else
			if msg.u?.username is CaoLiao.settings.get('Chatops_Username')
				msg.html = msg.msg
				return msg.html

			msg.html = msg.msg
			if _.trim(msg.html) isnt ''
				msg.html = _.escapeHTML msg.html

			# message = CaoLiao.callbacks.run 'renderMessage', msg
			msg.html = msg.html.replace /\n/gm, '<br/>'
			return msg.html

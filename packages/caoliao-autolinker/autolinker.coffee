###
# AutoLinker is a named function that will replace links on messages
# @param {Object} message - The message object
###

class AutoLinker
	constructor: (message) ->
		if _.trim message.html
			regUrls = new RegExp(CaoLiao.settings.get 'AutoLinker_UrlsRegExp')

			autolinker = new Autolinker
				stripPrefix: CaoLiao.settings.get 'AutoLinker_StripPrefix'
				urls:
					schemeMatches: CaoLiao.settings.get 'AutoLinker_Urls_Scheme'
					wwwMatches: CaoLiao.settings.get 'AutoLinker_Urls_www'
					tldMatches: CaoLiao.settings.get 'AutoLinker_Urls_TLD'
				email: CaoLiao.settings.get 'AutoLinker_Email'
				phone: CaoLiao.settings.get 'AutoLinker_Phone'
				twitter: false
				replaceFn: (autolinker, match) ->
					if match.getType() is 'url'
						if regUrls.test match.matchedText
							if match.matchedText.indexOf(Meteor.absoluteUrl()) is 0
								tag = match.buildTag()			# returns an `Autolinker.HtmlTag` instance for an <a> tag
								tag.setAttr('target', '' );		# sets target to empty, instead of _blank
								return tag
							return true
					return null

			regNonAutoLink = /(```\w*[\n ]?[\s\S]*?```+?)|(`(?:[^`]+)`)/
			if CaoLiao.settings.get 'Katex_Enabled'
				regNonAutoLink = /(```\w*[\n ]?[\s\S]*?```+?)|(`(?:[^`]+)`)|(\\\(\w*[\n ]?[\s\S]*?\\\)+?)/

			# Separate text in code blocks and non code blocks
			msgParts = message.html.split regNonAutoLink

			for part, index in msgParts
				if part?.length? > 0
					# Verify if this part is code
					codeMatch = part.match regNonAutoLink
					if not codeMatch?
						msgParts[index] = autolinker.link part

			# Re-mount message
			message.html = msgParts.join('')

		return message

CaoLiao.callbacks.add 'renderMessage', AutoLinker

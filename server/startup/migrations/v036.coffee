url = Npm.require 'url'
CaoLiao.Migrations.add
	version: 36
	up: ->
		loginHeader = CaoLiao.models.Settings.findOne _id: 'Layout_Login_Header'

		if not loginHeader?.value?
			return

		match = loginHeader.value.match(/<img\ssrc=['"]([^'"]+)/)
		if match? and match.length is 2
			requestUrl = match[1]
			if requestUrl[0] is '/'
				requestUrl = url.resolve(Meteor.absoluteUrl(), requestUrl)

			try
				Meteor.startup ->
					Meteor.setTimeout ->
						result = HTTP.get requestUrl, npmRequestOptions: {encoding: 'binary'}
						if result.statusCode is 200
							CaoLiao.Assets.setAsset(result.content, result.headers['content-type'], 'logo')
					, 30000
			catch e
				console.log e


		CaoLiao.models.Settings.remove _id: 'Layout_Login_Header'

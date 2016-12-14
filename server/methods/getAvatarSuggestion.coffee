@getAvatarSuggestionForUser = (user) ->
	console.log "getAvatarSuggestionForUser", user
	avatars = []
	if user.services.facebook?.id? and CaoLiao.settings.get 'Accounts_OAuth_Facebook'
		avatars.push
			service: 'facebook'
			url: "https://graph.facebook.com/#{user.services.facebook.id}/picture?type=large"

	if user.services.google?.picture? and user.services.google.picture isnt "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg" and CaoLiao.settings.get 'Accounts_OAuth_Google'
		avatars.push
			service: 'google'
			url: user.services.google.picture

	if user.services.wechat?.picture? and Meteor.settings.public.wechat
		avatars.push
			service: 'wechat'
			url: user.services.wechat.picture

	if user.services.weibo?.avatar_large? and Meteor.settings.public.weibo
		avatars.push
			service: 'weibo'
			url: user.services.weibo.avatar_large

	if user.services.github?.username? and CaoLiao.settings.get 'Accounts_OAuth_Github'
		avatars.push
			service: 'github'
			url: "https://avatars.githubusercontent.com/#{user.services.github.username}?s=200"

	if user.services.linkedin?.pictureUrl? and CaoLiao.settings.get 'Accounts_OAuth_Linkedin'
		avatars.push
			service: 'linkedin'
			url: user.services.linkedin.pictureUrl

	if user.services.twitter?.profile_image_url_https? and CaoLiao.settings.get 'Accounts_OAuth_Twitter'
		avatars.push
			service: 'twitter'
			url: user.services.twitter.profile_image_url_https

	if user.services.gitlab?.avatar_url? and CaoLiao.settings.get 'Accounts_OAuth_Gitlab'
		avatars.push
			service: 'gitlab'
			url: user.services.gitlab.avatar_url

	if user.services.sandstorm?.picture? and Meteor.settings.public.sandstorm
		avatars.push
			service: 'sandstorm'
			url: user.services.sandstorm.picture

	
	if user.emails?.length > 0
		for email in user.emails when email.verified is true
			avatars.push
				service: 'gravatar'
				url: Gravatar.imageUrl(email.address, {default: '404', size: 200, secure: true})

		for email in user.emails when email.verified isnt true
			avatars.push
				service: 'gravatar'
				url: Gravatar.imageUrl(email.address, {default: '404', size: 200, secure: true})
	

	validAvatars = {}
	console.log "avatars", avatars
	for avatar in avatars
		try
			result = HTTP.get avatar.url, {npmRequestOptions: {encoding: 'binary'}}
			console.log "result", result
			if result.statusCode is 200
				blob = "data:#{result.headers['content-type']};base64,"
				blob += Buffer(result.content, 'binary').toString('base64')
				avatar.blob = blob
				avatar.contentType = result.headers['content-type']
				validAvatars[avatar.service] = avatar
		catch e
			console.log "Error while handling the setting of the avatar from a url (#{avatar.url}) for #{user.username}:", e
			throw new Meteor.Error('error-avatar-url-handling', 'Error while handling avatar setting from a URL ('+ avatar.url +') for ' + user.username, { method: 'getAvatarSuggestion', url: avatar.url, username: user.username });
			
	return validAvatars


Meteor.methods
	getAvatarSuggestion: ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'getAvatarSuggestion' }
		
		@unblock()

		user = Meteor.user()
		getAvatarSuggestionForUser user


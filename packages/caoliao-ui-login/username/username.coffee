Template.username.onCreated ->
	self = this
	self.username = new ReactiveVar

	Meteor.call 'getUsernameSuggestion', (error, username) ->
		self.username.set
			ready: true
			username: username
		Meteor.defer ->
			self.find('input').focus()

Template.username.helpers
	
	fixCordovaBg: ->
		url = "/images/full-bg.jpeg"

		if Meteor.isCordova
			url = Meteor.absoluteUrl().replace(/\/$/, '') + url

		return url
	username: ->
		return Template.instance().username.get()
	minLength: ->
		return Settings.findOne("UTF8_Names_MinLength").value
	maxLength: ->
		return Settings.findOne("UTF8_Names_MaxLength").value

Template.username.events
	'submit #login-card': (event, instance) ->
		event.preventDefault()

		username = instance.username.get()
		username.empty = false
		username.error = false
		username.invalid = false
		username.invalidLength = false
		instance.username.set(username)

		button = $(event.target).find('button.login')
		CaoLiao.Button.loading(button)

		value = $("input").val().trim()
		if value is ''
			username.empty = true
			instance.username.set(username)
			CaoLiao.Button.reset(button)
			return

		Meteor.call 'setUsername', value, (err, result) ->
			if err?
				console.log err
				if err.error is 'username-invalid'
					username.invalid = true
				else if err.error is 'username-invalid-length'
					username.invalidLength = true
				else
					username.error = true
			else
				Meteor.call 'getAvatarSuggestion', (error, avatars) ->
					console.log avatars
					avatar = {}
					if avatars?.google
						if avatars?.google.blob
							avatar.blob = avatars?.google.blob
							avatar.contentType = avatars?.google.contentType
							avatar?.service = "blob"
						else
							avatar.url = avatars?.google.url
							avatar.contentType = avatars?.google.contentType
							avatar?.service = "url"

					if avatars?.facebook
						if avatars?.facebook.blob
							avatar.blob = avatars?.facebook.blob
							avatar.contentType = avatars?.facebook.contentType
							avatar?.service = "blob"
						else
							avatar.url = avatars?.facebook.url
							avatar.contentType = avatars?.facebook.contentType
							avatar?.service = "url"

					if avatars?.weibo
						if avatars?.weibo.blob
							avatar.blob = avatars?.weibo.blob
							avatar.contentType = avatars?.weibo.contentType
							avatar?.service = "blob"
						else
							avatar.url = avatars?.weibo.url
							avatar.contentType = avatars?.weibo.contentType
							avatar?.service = "url"

					else if avatars?.wechat
						if avatars?.wechat.blob
							avatar.blob = avatars?.wechat.blob
							avatar.contentType = avatars?.wechat.contentType
							avatar?.service = "blob"
						else
							avatar.url = avatars?.wechat.url
							avatar.contentType = avatars?.wechat.contentType
							avatar?.service = "url"

					console.log ""
					if avatar.url?
						Meteor.call 'setAvatarFromService', avatar?.url, '', 'url', (err) ->
							if err?.details?.timeToReset?
								toastr.error t('error-too-many-requests', { seconds: parseInt(err.details.timeToReset / 1000) })
						
					else if avatar.blob?
						Meteor.call 'setAvatarFromService', avatar?.blob, avatar?.contentType, "blob", (err) ->
							if err?.details?.timeToReset?
								toastr.error t('error-too-many-requests', { seconds: parseInt(err.details.timeToReset / 1000) })

Template.username.onRendered ->
	window.canvasStar();

	
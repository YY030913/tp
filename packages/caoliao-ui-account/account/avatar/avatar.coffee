Template.avatar.helpers
	imageUrl: ->
		username = this.username
		if not username? and this.userId?
			username = Meteor.users.findOne(this.userId)?.username

		if not username?
			return

		users = [].concat(username)
		
		return _.map users, (element, index, list) ->

			Session.get "avatar_random_#{element}"

			return getAvatarUrlFromUsername(element)

		###
		username = this.username
		if not username? and this.userId?
			username = Meteor.users.findOne(this.userId)?.username

		if not username?
			return

		Session.get "avatar_random_#{username}"

		url = getAvatarUrlFromUsername(username)
		#url = Template.instance().avatarUrl.get()#getAvatarUrlFromUsername(username)

		return "background-image:url(#{url});"
		###


Template.avatar.onRendered ->
	instance = this
	instance.nooverride = true
###
Template.avatar.onCreated ->
	@avatarUrl = new ReactiveVar ""
	Meteor.call 'getAvatarSuggestion', (error, avatars) ->
		if avatars?.google
			@avatarUrl.set avatars.google.url
		else if avatars?.wechat
			@avatarUrl.set avatars.wechat.url
		else if avatars?.weibo
			@avatarUrl.set avatars.weibo.url
		else
			key = "avatar_random_#{username}"
			random = Session?.keys[key] or 0
			if not username?
				console.log "not username"
				return
			if Meteor.isCordova
				console.log "isCordova"
				path = Meteor.absoluteUrl().replace /\/$/, ''
			else
				path = __meteor_runtime_config__.ROOT_URL_PATH_PREFIX || '';
			@avatarUrl.set "#{path}/avatar/#{encodeURIComponent(username)}.jpg?_dc=#{random}"
###
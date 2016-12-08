Template.groupAvatar.helpers
	imageUrl: ->
		users = this.users
		if not username? and this.userId?
			username = Meteor.users.findOne(this.userId)?.username

		if not username?
			return

		Session.get "avatar_random_#{username}"

		url = getAvatarUrlFromUsername(username)
		#url = Template.instance().avatarUrl.get()#getAvatarUrlFromUsername(username)

		return "background-image:url(#{url});"


Template.groupAvatar.onRendered ->
	instance = this
	instance.nooverride = true
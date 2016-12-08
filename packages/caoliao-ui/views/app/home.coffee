Template.home.helpers
	title: ->
		return CaoLiao.settings.get 'Layout_Home_Title'
	body: ->
		return CaoLiao.settings.get 'Layout_Home_Body'
	notificationCount: ->
		return ChatMessage.find({ rid: "GENERAL"}).count()

Template.home.onCreated ->
	console.log "home.onCreated"

Template.home.onRendered ->
	console.log "home.onRendered"
	instance = this;
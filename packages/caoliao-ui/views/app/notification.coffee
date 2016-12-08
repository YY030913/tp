Template.notification.helpers
	msgs: ->
		return ChatMessage.find { rid: "GENERAL"}

Template.notification.onCreated ->
	console.log "notification.onCreated"

Template.notification.onRendered ->
	console.log "notification.onRendered"


	instance = this;

	interval = Meteor.setInterval ->
		if $(".dropdown-button")?
			$(".dropdown-button").dropdown()
			Meteor.clearInterval(interval)
	,100
	###
	Tracker.autorun ->	
		if instance.subscriptionsReady() && Meteor.userId() &&  Session.get 'materialLoaded'
			$(".dropdown-button").dropdown()
	###
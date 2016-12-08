@Notifications = new class
	constructor: ->
		@debug = false
		@streamAll = new Meteor.Streamer 'notify-all'
		@streamRoom = new Meteor.Streamer 'notify-room'
		@streamUser = new Meteor.Streamer 'notify-user'

		if @debug is true
			@onAll -> console.log "CaoLiao.Notifications: onAll", arguments
			@onUser -> console.log "CaoLiao.Notifications: onAll", arguments


	notifyRoom: (room, eventName, args...) ->
		console.log "CaoLiao.Notifications: notifyRoom", arguments if @debug is true

		args.unshift "#{room}/#{eventName}"
		@streamRoom.emit.apply @streamRoom, args

	notifyUser: (userId, eventName, args...) ->
		console.log "CaoLiao.Notifications: notifyUser", arguments if @debug is true

		args.unshift "#{userId}/#{eventName}"
		@streamUser.emit.apply @streamUser, args

	onAll: (eventName, callback) ->
		@streamAll.on eventName, callback

	onRoom: (room, eventName, callback) ->
		if @debug is true
			@streamRoom.on room, -> console.log "CaoLiao.Notifications: onRoom #{room}", arguments

		@streamRoom.on "#{room}/#{eventName}", callback

	onUser: (eventName, callback) ->
		@streamUser.on "#{Meteor.userId()}/#{eventName}", callback


	unAll: (callback) ->
		@streamAll.removeListener 'notify', callback

	unRoom: (room, eventName, callback) ->
		@streamRoom.removeListener "#{room}/#{eventName}", callback

	unUser: (callback) ->
		@streamUser.removeListener Meteor.userId(), callback

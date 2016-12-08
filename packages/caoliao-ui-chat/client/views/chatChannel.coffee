slideChanged = (index) ->
	$('.bar-progress').css('left', 50 * index + '%');

Template.chatChannel.helpers
	languages: ->
		languages = TAPi18n.getLanguages()
		result = []
		for key, language of languages
			result.push _.extend(language, { key: key })
		return _.sortBy(result, 'key')

	userLanguage: (key) ->
		return (Meteor.user().language or defaultUserLanguage())?.split('-').shift().toLowerCase() is key

	messages: ->
		return CaoLiao.models.Messages.find {
				rid: "GENERAL"
			}, {
				sort: {
					ts: 1
				}
			}

	canShowRoomType: ->
		return CaoLiao.roomTypes.checkCondition(@)

	roomType: ->
		return CaoLiao.roomTypes.getTypes()

	templateName: ->
		return @template

	caoliao: ->
		query =
			rid: "GENERAL"
			t: { $in: ['c']},
			open: true

		if CaoLiao.settings.get 'Favorite_Rooms'
			query.f = { $ne: true }

		if Meteor.user()?.settings?.preferences?.unreadRoomsMode
			query.alert =
				$ne: true

		return (ChatSubscription.find query, { sort: 't': 1, 'name': 1 }).fetch()[0]

	starredRooms: ->
		query = { f: true, open: true }

		if Meteor.user()?.settings?.preferences?.unreadRoomsMode
			query.alert =
				$ne: true

		return ChatSubscription.find query, { sort: 't': 1, 'name': 1 }

	channelRooms: ->
		query =
			rid: {
				$ne: "GENERAL"
			}
			t: { $in: ['c']},
			open: true

		if CaoLiao.settings.get 'Favorite_Rooms'
			query.f = { $ne: true }

		if Meteor.user()?.settings?.preferences?.unreadRoomsMode
			query.alert =
				$ne: true
				
		return ChatSubscription.find query, { sort: 't': 1, 'name': 1 }

	privateRooms: ->
		query = { t: { $in: ['p']}, f: { $ne: true }, open: true }

		if Meteor.user()?.settings?.preferences?.unreadRoomsMode
			query.alert =
				$ne: true

		return ChatSubscription.find query, { sort: 't': 1, 'name': 1 }

	directRooms: ->
		query = { t: { $in: ['d']}, f: { $ne: true }, open: true }

		if Meteor.user()?.settings?.preferences?.unreadRoomsMode
			query.alert =
				$ne: true

		return ChatSubscription.find query, { sort: 't': 1, 'name': 1 }

Template.chatChannel.events

Template.chatChannel.onRendered ->
	slideTab = new SlideTab('.panes', {
		initialPane: 0,
		slideChanged: slideChanged
	});

	pages = [0, 0, 0, 0];

	# slideTab.dropload = $('.wraper').dropload
	#	scrollArea: window,
	#	loadDownFn: ->
	#		slideTab.resetHeight();

	$('.nav').on 'click', '.nav-tab', ->
		index = $('.nav-tab').index(this);
		slideTab.slideTo(index);
		slideChanged(index);
		slideTab.resetHeight();

	#Tracker.autorun ->
	#	slideTab.resetHeight();
	
Template.channels.helpers
	isActive: ->
		return 'active' if ChatSubscription.findOne({ t: { $in: ['c']}, f: { $ne: true }, open: true, rid: Session.get('openedRoom') }, { fields: { _id: 1 } })?
	roomscount: ->
		query =
			t: { $in: ['c']},
			open: true

		if CaoLiao.settings.get 'Favorite_Rooms'
			query.f = { $ne: true }

		if Meteor.user()?.settings?.preferences?.unreadRoomsMode
			query.alert =
				$ne: true
		return ChatSubscription.find(query, { sort: 't': 1, 'name': 1 }).count()

	rooms: ->
		query =
			t: { $in: ['c']},
			open: true

		#if CaoLiao.settings.get 'Favorite_Rooms'
		#	query.f = { $ne: true }

		if Meteor.user()?.settings?.preferences?.unreadRoomsMode
			query.alert =
				$ne: true

		query.rid = {$ne: "GENERAL"}
		# console.log ChatSubscription.find(query, { sort: 't': 1, 'name': 1 }).fetch();
		return ChatSubscription.find query, { sort: 't': 1, 'name': 1 }

Template.channels.events
	'click .add-room': (e, instance) ->
		if CaoLiao.authz.hasAtLeastOnePermission('create-c')
			SideNav.setFlex "createChannelFlex"
			SideNav.openFlex()
		else
			e.preventDefault()

	'click .more-channels': ->
		SideNav.setFlex "listChannelsFlex"
		SideNav.openFlex()

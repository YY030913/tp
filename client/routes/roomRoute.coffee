FlowRouter.goToRoomById = (roomId) ->
	subscription = ChatSubscription.findOne({rid: roomId})
	
	if subscription?
		FlowRouter.go CaoLiao.roomTypes.getRouteLink subscription.t, subscription

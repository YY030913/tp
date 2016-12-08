FlowRouter.goToTagById = (tagId) ->
	subscription = DebateSubscription.findOne({tid: tagId})
	
	if subscription?
		FlowRouter.go CaoLiao.tagTypes.getRouteLink subscription.t, subscription

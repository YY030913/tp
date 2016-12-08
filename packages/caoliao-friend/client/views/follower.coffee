Template.follower.helpers
	followers: ->
		CaoLiao.models.Follow.find({"u._id": FlowRouter.current().params.id}).fetch()
		
		

Template.follower.onCreated ->
	

Template.follower.onRendered ->
	

Template.follower.events

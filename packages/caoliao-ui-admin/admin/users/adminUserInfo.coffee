Template.adminUserInfo.helpers
	data: ->
		console.log Meteor.users.findOne FlowRouter.getParam('uid')
		return Meteor.users.findOne FlowRouter.getParam('uid')

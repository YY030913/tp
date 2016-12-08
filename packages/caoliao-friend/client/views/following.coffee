Template.following.helpers
	friends: ->
		exist = []
		return _.map((_.sortBy(CaoLiao.models.Follow.find({"friend._id": FlowRouter.current().params.id}).fetch(), "u.pinyin")), (obj) ->
			if new RegExp(/[a-z]/).test(obj.u.pinyin.substr(0, 1))
				if !exist[obj.u.pinyin.substr(0, 1)]?
					obj.friendCate = obj.u.pinyin.substr(0, 1)
			else
				if !exist["#"]?
					obj.friendCate = "#"

			return obj
		)
	isSubsc: ->
		return FlowRouter.subsReady('follow')

	notcurrentuser: (userId) ->
		Meteor.userId() == userId
		return true

	followed: (userId) ->
		return CaoLiao.models.Follow.find({"friend._id": userId, "u._id": Meteor.userId()}).count()
	
		
	

Template.following.onCreated ->
	

Template.following.onRendered ->
	

Template.following.events

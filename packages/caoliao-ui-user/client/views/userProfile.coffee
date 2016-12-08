isSubscribed =  ->
	return FlowRouter.subsReady('userProfile') and FlowRouter.subsReady('follow')

Template.userProfile.helpers
	followed: ->
		return CaoLiao.models.Follow.find({"friend._id": FlowRouter.current().params.id, "u._id": Meteor.userId()}).count()
	notcurrentuser: ->
		return Meteor.userId() == FlowRouter.current().params.id
	profession: ->
		return ""
	followerscount: ->
		if FlowRouter.current().params.id?
			return CaoLiao.models.Follow.find({"u._id": FlowRouter.current().params.id}).count()
		else
			return CaoLiao.models.Follow.find(Meteor.userId()).count()
	followingcount: ->
		if FlowRouter.current().params.id?
			return CaoLiao.models.Follow.find({"friend._id": FlowRouter.current().params.id}).count()
		else
			return CaoLiao.models.Follow.find(Meteor.userId()).count()
	username: ->
		if FlowRouter.current().params.id?
			return ProfileUsers.findOne(FlowRouter.current().params.id).username
		else
			return ProfileUsers.findOne(Meteor.userId())?.username
	t: ->
		if FlowRouter.current().params.id?
			return ProfileUsers.findOne(FlowRouter.current().params.id).ts
		else
			return ProfileUsers.findOne(Meteor.userId()).ts
	htmlBody: ->
		if FlowRouter.current().params.id?
			return ProfileUsers.findOne(FlowRouter.current().params.id).htmlBody
		else
			return ProfileUsers.findOne(Meteor.userId()).htmlBody
	createTime: ->
		return moment(this.ts).locale(TAPi18n.getLanguage()).format('L LT')
	isSub: ->
		return isSubscribed();
	isEmpty: ->
		if FlowRouter.current().params.id?
			return ProfileUsers.find(FlowRouter.current().params.id).count() == 0;
		else
			return ProfileUsers.find(Meteor.userId()).count() == 0;

	userstags: ->
		if FlowRouter.current().params.id?
			return ProfileUsers.findOne(FlowRouter.current().params.id).tags
		else
			return ProfileUsers.findOne(Meteor.userId()).tags

	company: ->
		return ""
	introduction: ->
		return ""
	jointat: ->
		if FlowRouter.current().params.id?
			return ProfileUsers.findOne(FlowRouter.current().params.id).ts
		else
			return ProfileUsers.findOne(Meteor.userId()).ts
	started: ->
		return false

	visualStatus: ->
		switch ProfileUsers.findOne(FlowRouter.current().params.id).status
			when "away"
				visualStatus = t("away")
			when "busy"
				visualStatus = t("busy")
			when "offline"
				visualStatus = t("invisible")
		return visualStatus

Template.userProfile.onCreated ->
	# @users = new ReactiveVar Object

Template.userProfile.onRendered ->
	self = this

	# Meteor.call("updateusersRead", FlowRouter.current().params.id)
	
	###
	Template.instance().users.set({result: true});
	Meteor.call("getusers", FlowRouter.current().params.id, (error, result)->
		if error?
			toastr.error t(error.message)
		else 
			ProfileUsers.upsert {_id: FlowRouter.current().params.id}, result
			self.users.set(result);
	);
	###
Template.userProfile.onDestroyed ->
	console.log("onDestroyed")

Template.userProfile.events

	"click .follow": ->
		Meteor.call "addFollow", FlowRouter.current().params.id, (error, result)->
			if error?
				toastr.error t(error.message)

	"click .unfollow": ->
		Meteor.call "cancelFollow", FlowRouter.current().params.id, (error, result)->
			if error?
				toastr.error t(error.message)

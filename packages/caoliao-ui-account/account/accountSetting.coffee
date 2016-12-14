Template.accountSetting.helpers
	allowUserProfileChange: ->
		return CaoLiao.settings.get("Accounts_AllowUserProfileChange")
	allowUserAvatarChange: ->
		return CaoLiao.settings.get("Accounts_AllowUserAvatarChange")
	myUserInfo: ->
		visualStatus = "online"
		username = Meteor.user()?.username
		shortCountry = Meteor.user()?.shortCountry
		medals = Meteor.user()?.medals
		introduction = Meteor.user()?.introduction
		switch Session.get('user_' + username + '_status')
			when "away"
				visualStatus = t("away")
			when "busy"
				visualStatus = t("busy")
			when "offline"
				visualStatus = t("invisible")
		return {
			name: Session.get('user_' + username + '_name')
			status: Session.get('user_' + username + '_status')
			visualStatus: visualStatus
			_id: Meteor.userId()
			username: username
			shortCountry: shortCountry
			medals: medals
			introduction: introduction
		}
	canEdit: (uid)->
		return Meteor.userId() == uid
	debateCount: ->
		return Meteor.user()?.createDebateCont || 0
	followCount: ->
		if FlowRouter.current().params.id?
			return CaoLiao.models.Follow.find({"u._id": FlowRouter.current().params.id}).count()
		else
			return CaoLiao.models.Follow.find(Meteor.userId()).count()
	followingCount: ->
		if FlowRouter.current().params.id?
			return CaoLiao.models.Follow.find({"friend._id": FlowRouter.current().params.id}).count()
		else
			return CaoLiao.models.Follow.find(Meteor.userId()).count()


Template.accountSetting.onCreated ->
	console.log "accountSetting"

Template.accountSetting.onRendered ->
	
Template.accountSetting.events

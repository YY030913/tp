Blaze.registerHelper 'pathFor', (path, kw) ->
	return FlowRouter.path path, kw.hash

BlazeLayout.setRoot 'body'

###
enterPage = (context) ->
	# context is the output of `FlowRouter.current()`
	options = {
		animation: 'slide' # What animation to use
	};

	animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
	$(".main-content").addClass('animated bounceInleft').one(animationEnd, ->
		$(this).removeClass('animated bounceInleft');
	);

exitPage = (context) ->
	# context is the output of `FlowRouter.current()`
	animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
	$(".main-content").addClass('animated bounceOutRight').one(animationEnd, ->
		$(this).removeClass('animated bounceOutRight');
	);



FlowRouter.triggers.enter([enterPage]);
FlowRouter.triggers.exit([exitPage]);


enterPage = (context) ->
	$("body").addClass("loaded");
FlowRouter.triggers.enter([enterPage]);
exitPage = (context) ->
	$("body").removeClass("loaded");
FlowRouter.triggers.exit([exitPage]);

###

FlowRouter.subscriptions = ->
	Tracker.autorun =>
		RoomManager.init()
		TagManager.init()
		@register 'ads', Meteor.subscribe('ads')
		@register 'userData', Meteor.subscribe('userData')
		@register 'friendSubscriptionData', Meteor.subscribe('friendSubscriptionData')
		@register 'activeUsers', Meteor.subscribe('activeUsers')
		@register 'admin-settings', Meteor.subscribe('admin-settings')

FlowRouter.route '/',
	name: 'index'

	action: ->
		BlazeLayout.render 'main', {center: 'pageLoading'}
		if not Meteor.userId()
			return FlowRouter.go 'typeDebates', {type: 'o'}


		Tracker.autorun (c) ->
			if FlowRouter.subsReady() is true
				Meteor.defer ->
					if Meteor.user()? && Meteor.user().defaultRoom?
						room = Meteor.user().defaultRoom.split('/')
						FlowRouter.go room[0], {name: room[1]}
					else
						FlowRouter.go 'typeDebates', {type: 'o'}

				c.stop()


FlowRouter.route '/login',
	name: 'login'

	action: ->
		FlowRouter.go 'home'


FlowRouter.route '/home',
	name: 'home'

	subscriptions: (params, queryParams) ->

	action: ->
		FlowRouter.go 'typeDebates', {type: 'o'}
		###
		Tracker.autorun (c) ->
			
			if FlowRouter.subsReady() is true
				if Meteor.userId()
					FlowRouter.go 'typeDebates', {type: 'o'}
				
				else
					CaoLiao.TabBar.showGroup 'home'
					FlowRouter.go 'typeDebates', {type: 'o'}
					#BlazeLayout.render 'main', {center: 'home'}
				
				c.stop()
			else
				BlazeLayout.render 'main', {center: 'pageLoading'}
			
		KonchatNotification.getDesktopPermission()
		###

FlowRouter.route '/messages',
	name: 'messages'

	subscriptions: (params, queryParams) ->

	action: ->
		Tracker.autorun (c) ->
			
			if FlowRouter.subsReady() is true
				BlazeLayout.render 'main', {center: 'messageList'}
				c.stop()
			else
				BlazeLayout.render 'main', {center: 'pageLoading'}
			

FlowRouter.route '/searchs',
	name: 'searchs'

	subscriptions: (params, queryParams) ->

	action: ->
		Tracker.autorun (c) ->
			
			if FlowRouter.subsReady() is true
				BlazeLayout.render 'main', {center: 'stageSearch'}
				c.stop()
			else
				BlazeLayout.render 'main', {center: 'pageLoading'}

FlowRouter.route '/searchs/:type?/:keyword?',
	name: 'searchsResult'

	subscriptions: (params, queryParams) ->

	action: ->
		Tracker.autorun (c) ->
			
			if FlowRouter.subsReady() is true
				BlazeLayout.render 'main', {center: 'stageSearchResult'}
				c.stop()
			else
				BlazeLayout.render 'main', {center: 'pageLoading'}


FlowRouter.route '/changeavatar',
	name: 'changeAvatar'

	action: ->
		CaoLiao.TabBar.showGroup 'changeavatar'
		BlazeLayout.render 'main', {center: 'avatarPrompt'}

FlowRouter.route '/account/:group?',
	name: 'account'

	action: (params) ->
		unless params.group
			params.group = 'Setting'
		params.group = _.capitalize params.group, true
		#CaoLiao.TabBar.showGroup 'account'
		BlazeLayout.render 'main', { center: "account#{params.group}" }


FlowRouter.route '/chat/:group/:slug?',
	name: 'chat'

	action: (params) ->
		unless params.group
			params.group = 'Channel'
		params.group = _.capitalize params.group, true
		CaoLiao.TabBar.showGroup 'chat'
		BlazeLayout.render 'main', { center: "chat#{params.group}" }

FlowRouter.route '/history/private',
	name: 'privateHistory'

	subscriptions: (params, queryParams) ->
		@register 'privateHistory', Meteor.subscribe('privateHistory')

	action: ->
		Session.setDefault('historyFilter', '')
		CaoLiao.TabBar.showGroup 'private-history'
		BlazeLayout.render 'main', {center: 'privateHistory'}


FlowRouter.route '/terms-of-service',
	name: 'terms-of-service'

	action: ->
		Session.set 'cmsPage', 'Layout_Terms_of_Service'
		BlazeLayout.render 'cmsPage'

FlowRouter.route '/privacy-policy',
	name: 'privacy-policy'

	action: ->
		Session.set 'cmsPage', 'Layout_Privacy_Policy'
		BlazeLayout.render 'cmsPage'

FlowRouter.route '/search/:type',
	name: 'search'

	action: (params) ->
		Session.set 'search', {type: params.type, name: params.name}
		BlazeLayout.render 'main', {center: "#{params.type}Search"}

FlowRouter.route '/room-not-found/:type/:name',
	name: 'room-not-found'

	action: (params) ->
		Session.set 'roomNotFound', {type: params.type, name: params.name}
		BlazeLayout.render 'main', {center: 'roomNotFound'}

FlowRouter.route '/fxos',
	name: 'firefox-os-install'

	action: ->
		BlazeLayout.render 'fxOsInstallPrompt'

FlowRouter.route '/register/:hash',
	name: 'register-secret-url'
	action: (params) ->
		BlazeLayout.render 'secretURL'

		# if CaoLiao.settings.get('Accounts_RegistrationForm') is 'Secret URL'
		# 	Meteor.call 'checkRegistrationSecretURL', params.hash, (err, success) ->
		# 		if success
		# 			Session.set 'loginDefaultState', 'register'
		# 			BlazeLayout.render 'main', {center: 'home'}
		# 			KonchatNotification.getDesktopPermission()
		# 		else
		# 			BlazeLayout.render 'logoLayout', { render: 'invalidSecretURL' }
		# else
		# 	BlazeLayout.render 'logoLayout', { render: 'invalidSecretURL' }

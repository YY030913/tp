
saveScrollPosition = (context) ->
	pathInfo = {
		path: context.path,
		scrollPosition: $('body').scrollTop()
	};

	# add a new path and remove the first path
	# using as a queue
	# this.previousPaths.push(pathInfo);
	# this.previousPaths.shift();

jumpToPrevScrollPosition = (context) ->
	path = context.path;
	scrollPosition = 0;
	# prevPathInfo = previousPaths[0];
	# if prevPathInfo && prevPathInfo.path == context.path
	# 	scrollPosition = prevPathInfo.scrollPosition;

	if scrollPosition == 0
		# we can scroll right away since we don't need to wait for rendering
		$('body').animate({scrollTop: scrollPosition}, 0);
	else
		# Now we need to wait a bit for blaze/react does rendering.
		# We assume, there's subs-manager and we've previous page's data.
		# Here 10 millis deley is a arbitary value with some testing.
		setTimeout( ->
			$('body').animate({scrollTop: scrollPosition}, 0);
		, 10);


notifyGoogleAnalytics = (context) ->
	ga('send', 'pageview', context.path);


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


#FlowRouter.triggers.enter([enterPage, jumpToPrevScrollPosition]);
#FlowRouter.triggers.exit([exitPage, saveScrollPosition]);

###
FlowRouter.route '/debates',
	name: 'debates'

	action: (params) ->
		console.log "BlazeLayout.render debates"
		BlazeLayout.render 'main', 
			center: "debates"
			pageTemplate: 'debates'
###

FlowRouter.route '/debates/:type',
	name: 'typeDebates'

	action: (params) ->
		BlazeLayout.render 'main', 
			pageTitle: 'Discory'
			center: "typeDebates"
			pageTemplate: 'typeDebates'

FlowRouter.route '/debate/confirm/:slug?',
	name: 'debate-confirm'

	subscriptions: (params, queryParams) ->
		@register 'debate', Meteor.subscribe('debate', params.slug)

	action: (params) ->
		BlazeLayout.render 'main', 
			center: "debateCateConfirm"
			pageTemplate: 'debateCateConfirm'

FlowRouter.route '/debate/:slug?',
	name: 'debate'

	subscriptions: (params, queryParams) ->
		@register 'debate', Meteor.subscribe('debate', params.slug)

	action: (params) ->
		BlazeLayout.render 'main', 
			center: "debate"
			pageTemplate: 'debate'

FlowRouter.route '/debate/edit/:slug?',
	name: 'debate-edit'

	subscriptions: (params, queryParams) ->
		@register 'debate', Meteor.subscribe('debate', params.slug)
		@register 'typeSelectTag', Meteor.subscribe('typeSelectTag')

	action: (params) ->
		BlazeLayout.render 'main', 
			center: "debateEdit"
			pageTemplate: 'debateEdit'


FlowRouter.route '/user/debates',
	name: 'userDebates'
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'userDebates'
			pageTitle: 'User_Debate'
			pageTemplate: 'userDebates'

FlowRouter.route '/user/debates/:uid',
	name: 'userDebates'
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'userDebates'
			pageTitle: 'User_Debate'
			pageTemplate: 'userDebates'

FlowRouter.route '/favorite/debates',
	name: 'favorite-debates'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'favorite-debates'
		BlazeLayout.render 'main',
			center: 'debateFlag'
			pageTitle: t('Favorite_Debates')
			pageTemplate: 'debateFlag'

FlowRouter.route '/admin/debates',
	name: 'admin-debates'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-debates'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Integrations')
			pageTemplate: 'debates'

FlowRouter.route '/admin/debates/new',
	name: 'admin-debates-new'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-debates'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Integration_New')
			pageTemplate: 'debatesNew'

FlowRouter.route '/admin/debates/incoming/:id?',
	name: 'admin-debates-incoming'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-debates'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Integration_Incoming_WebHook')
			pageTemplate: 'debatesIncoming'
			params: params

FlowRouter.route '/admin/debates/outgoing/:id?',
	name: 'admin-debates-outgoing'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-debates'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Integration_Outgoing_WebHook')
			pageTemplate: 'debatesOutgoing'
			params: params
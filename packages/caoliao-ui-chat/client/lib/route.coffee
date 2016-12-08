FlowRouter.route '/chat',
	name: 'chatChannel'
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'chatChannel'
			pageTitle: t('Chat')
			pageTemplate: 'chatChannel'
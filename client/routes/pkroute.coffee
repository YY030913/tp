FlowRouter.route '/pk',
	name: 'pk'
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'pk'
			pageTemplate: 'pk'
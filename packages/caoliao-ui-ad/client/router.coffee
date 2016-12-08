FlowRouter.route '/admin/ad',
	name: 'admin-ad'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-ad'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Ad')
			pageTemplate: 'ads'

FlowRouter.route '/admin/ad/:name?/edit',
	name: 'admin-ad-edit'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-ad'
		BlazeLayout.render 'main',
			center: 'pageContainer'
			pageTitle: t('Ad_Editing')
			pageTemplate: 'adEdit'

FlowRouter.route '/admin/ad/new',
	name: 'admin-ad-new'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-ad'
		BlazeLayout.render 'main',
			center: 'pageContainer'
			pageTitle: t('Ad_Editing')
			pageTemplate: 'adEdit'

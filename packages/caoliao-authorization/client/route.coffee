FlowRouter.route '/admin/permissions',
	name: 'admin-permissions'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-permissions'
		BlazeLayout.render 'main',
			center: 'pageContainer'
			pageTitle: t('Permissions')
			pageTemplate: 'permissions'

FlowRouter.route '/admin/permissions/:name?/edit',
	name: 'admin-permissions-edit'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-permissions'
		BlazeLayout.render 'main',
			center: 'pageContainer'
			pageTitle: t('Role_Editing')
			pageTemplate: 'permissionsRole'

FlowRouter.route '/admin/permissions/new',
	name: 'admin-permissions-new'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-permissions'
		BlazeLayout.render 'main',
			center: 'pageContainer'
			pageTitle: t('Role_Editing')
			pageTemplate: 'permissionsRole'

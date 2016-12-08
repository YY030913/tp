FlowRouter.route '/admin/userInfo/:uid',
	name: 'admin-userInfo'
	action: (params) ->
		CaoLiao.TabBar.showGroup 'admin-userInfo'
		BlazeLayout.render 'main',
			center: 'adminUserInfo'
			pageTitle: t('UserInfo')
			pageTemplate: 'adminUserInfo'
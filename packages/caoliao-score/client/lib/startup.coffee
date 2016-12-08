Meteor.startup ->
	AccountBox.addItem
		name: t('User_Score'),
		icon: 'icon-graduation-cap',
		href: 'user/score',
		condition: ->
			CaoLiao.settings.get('User_Score_Enabled') && CaoLiao.authz.hasAllPermission('view-user-score')
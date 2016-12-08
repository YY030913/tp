Meteor.startup ->
	AccountBox.addItem
		name: 'User_Activity',
		icon: 'icon-activity',
		href: 'user/activity',
		condition: ->
			CaoLiao.settings.get('User_Activity_Enabled') && CaoLiao.authz.hasAllPermission('view-user-activity')
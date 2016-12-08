Meteor.startup ->
	AccountBox.addItem
		name: 'User_Debate',
		icon: 'icon-comment',
		href: 'user/debates',
		condition: ->
			CaoLiao.settings.get('User_Debate_Enabled') && CaoLiao.authz.hasAllPermission('view-user-debates')
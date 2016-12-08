###
Meteor.startup ->
	AccountBox.addItem
		name: 'User_Profile',
		icon: 'icon-user',
		href: 'user/profile',
		condition: ->
			CaoLiao.settings.get('User_Profile_Enabled') && CaoLiao.authz.hasAllPermission('view-user-profile')
###
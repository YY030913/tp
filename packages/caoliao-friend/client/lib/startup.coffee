###
Meteor.startup ->
	AccountBox.addItem
		name: t('User_Friend'),
		icon: 'icon-users',
		href: 'friend',
		condition: ->
			CaoLiao.settings.get('User_Friend_Enabled') && CaoLiao.authz.hasAllPermission('view-user-friend')
###
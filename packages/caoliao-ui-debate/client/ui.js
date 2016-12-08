Meteor.startup( function() {
	AccountBox.addItem({
		name: 'userDebates',
		icon: 'icon-comment',
		href: 'user/debates',
		condition: () => {
			return CaoLiao.settings.get('User_Debate_Enabled') && CaoLiao.authz.hasAllPermission('view-user-debates');
		}
	});
})
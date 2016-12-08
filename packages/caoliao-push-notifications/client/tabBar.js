Meteor.startup(function() {
	CaoLiao.TabBar.addButton({
		groups: ['channel', 'privategroup', 'directmessage'],
		id: 'push-notifications',
		i18nTitle: 'Notifications',
		icon: 'icon-bell-alt',
		template: 'pushNotificationsFlexTab',
		order: 2
	});

	CaoLiao.OptionTabBar.addButton({
		groups: ['channel', 'privategroup', 'directmessage'],
		id: 'push-notifications',
		i18nTitle: 'Notifications',
		icon: 'icon-bell-alt',
		template: 'pushNotificationsFlexTab',
		route: {
			name: 'pushNotificationsFlexTab',
			path: '/pushNotificationsFlexTab/:rid',
			action(params) {
				BlazeLayout.render('main', {
				  	center: 'pushNotificationsFlexTab'
				});
			},
			link(sub) {
				return {
					rid: sub.rid
				};
			}
		},
		order: 2
	});
});

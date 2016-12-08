Meteor.startup ->
	CaoLiao.TabBar.addButton({
		groups: ['channel', 'privategroup', 'directmessage'],
		id: 'starred-messages',
		i18nTitle: 'Starred_Messages',
		icon: 'icon-star',
		template: 'starredMessages',
		order: 3
	})

	CaoLiao.OptionTabBar.addButton({
		groups: ['channel', 'privategroup', 'directmessage'],
		id: 'starred-messages',
		i18nTitle: 'Starred_Messages',
		icon: 'icon-star',
		template: 'starredMessages',
		route: {
			name: 'starredMessages',
			path: '/starredMessages/:rid',
			action: (params) ->
				BlazeLayout.render('main', {
				  	center: 'starredMessages'
				});
			,
			link: (sub) ->
				return {
					rid: sub.rid
				};
		},
		order: 3
	})

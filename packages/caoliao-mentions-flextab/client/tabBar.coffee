Meteor.startup ->
	CaoLiao.TabBar.addButton({
		groups: ['channel', 'privategroup'],
		id: 'mentions',
		i18nTitle: 'Mentions',
		icon: 'icon-at',
		template: 'mentionsFlexTab',
		order: 3
	})


	CaoLiao.OptionTabBar.addButton({
		groups: ['channel', 'privategroup'],
		id: 'mentions',
		i18nTitle: 'Mentions',
		icon: 'icon-at',
		template: 'mentionsFlexTab',
		route: {
			name: 'mentionsFlexTab',
			path: '/mentionsFlexTab/:rid',
			action: (params) ->
				BlazeLayout.render('main', {
				  	center: 'mentionsFlexTab'
				});
			,
			link: (sub) ->
				return {
					rid: sub.rid
				};
		},
		order: 3
	})

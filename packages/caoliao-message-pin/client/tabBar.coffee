Meteor.startup ->
	Tracker.autorun ->
		if CaoLiao.settings.get 'Message_AllowPinning'
			CaoLiao.TabBar.addButton({
				groups: ['channel', 'privategroup', 'directmessage'],
				id: 'pinned-messages',
				i18nTitle: 'Pinned_Messages',
				icon: 'icon-pin',
				template: 'pinnedMessages',
				order: 10
			})

			CaoLiao.OptionTabBar.addButton({
				groups: ['channel', 'privategroup', 'directmessage'],
				id: 'pinned-messages',
				i18nTitle: 'Pinned_Messages',
				icon: 'icon-pin',
				template: 'pinnedMessages',
				route: {
					name: 'pinnedMessages',
					path: '/pinnedMessages/:rid',
					action: (params) ->
						BlazeLayout.render('main', {
						  	center: 'pinnedMessages'
						});
					,
					link: (sub) ->
						return {
							rid: sub.rid
						};
				},
				order: 10
			})
		else
			CaoLiao.TabBar.removeButton 'pinned-messages'
			CaoLiao.OptionTabBar.removeButton 'pinned-messages'

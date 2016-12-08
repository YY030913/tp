Meteor.startup ->
	Tracker.autorun ->
		if CaoLiao.settings.get('Chatops_Enabled')
			console.log 'Adding chatops to tabbar'
			CaoLiao.TabBar.addButton
				groups: ['channel', 'privategroup', 'directmessage']
				id: 'chatops-button2'
				i18nTitle: 'caoliao-chatops:Chatops_Title'
				icon: 'icon-hubot'
				template: 'chatops-dynamicUI'
				order: 4

			console.log 'Adding chatops to tabbar'
			CaoLiao.TabBar.addButton
				groups: ['channel', 'privategroup', 'directmessage']
				id: 'chatops-button3'
				i18nTitle: 'caoliao-chatops:Chatops_Title'
				icon: 'icon-inbox'
				template: 'chatops_droneflight'
				width: 675
				order: 5
		else
			CaoLiao.TabBar.removeButton 'chatops-button2'
			CaoLiao.TabBar.removeButton 'chatops-button3'

CaoLiao.OptionTabBar.addButton
	groups: ['channel', 'privategroup', 'directmessage']
	id: 'open-video'
	i18nTitle: 'Initiate_Debate'
	icon: 'mdi-av-videocam'
	template: ''
	action: (params) ->
		if Session.get('openedRoom')?
			WebRTC.getInstanceByRoomId(Session.get('openedRoom')).startCall({audio: true, video: true})
	order: 1

CaoLiao.OptionTabBar.addButton
	groups: ['channel', 'privategroup']
	id: 'join-video'
	i18nTitle: 'Joined_Debate'
	icon: 'mdi-av-videocam'
	template: ''
	action: (params) ->
		if Session.get('openedRoom')?
			WebRTC.getInstanceByRoomId(Session.get('openedRoom')).joinCall({audio: true, video: true})
	order: 2

CaoLiao.OptionTabBar.addButton
	groups: ['channel']
	id: 'view-subject'
	i18nTitle: 'View_Subject'
	icon: 'icon-align-right'
	template: ''
	action: (params) ->
		console.log params
	order: 0
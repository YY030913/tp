Template.chat.helpers
	flexOpened: ->
		return 'opened' if CaoLiao.TabBar.isFlexOpen()
	arrowPosition: ->
		console.log 'room.helpers arrowPosition' if window.rocketDebug
		return 'left' unless CaoLiao.TabBar.isFlexOpen()

Template.chat.onRendered ->
	Tracker.afterFlush ->
		SideNav.setFlex "chatFlex"
		SideNav.openFlex()


Template.stageSearchModal.helpers
	flexOpened: ->
		return 'opened' if CaoLiao.TabBar.isFlexOpen()
	arrowPosition: ->
		console.log 'room.helpers arrowPosition' if window.rocketDebug
		return 'left' unless CaoLiao.TabBar.isFlexOpen()

Template.stageSearchModal.onRendered ->
	Tracker.afterFlush ->
		###
		SideNav.setFlex "accountFlex"
		SideNav.openFlex()
		###

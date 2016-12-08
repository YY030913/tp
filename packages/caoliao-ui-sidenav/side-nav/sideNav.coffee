Template.sideNav.helpers

	alert: (_id)->
		return DebateSubscription.findOne(_id).alert

	unread: (_id)->
		return DebateSubscription.findOne(_id).unread

	subReady: (sub)->
		return FlowRouter.subsReady(sub);
		
	userId: ->
		return Meteor.userId();
	flexTemplate: ->
		return SideNav.getFlex().template

	flexData: ->
		return SideNav.getFlex().data

	footer: ->
		return CaoLiao.settings.get 'Layout_Sidenav_Footer'

	showStarredRooms: ->
		favoritesEnabled = CaoLiao.settings.get 'Favorite_Rooms'
		hasFavoriteRoomOpened = ChatSubscription.findOne({ f: true, open: true })

		return true if favoritesEnabled and hasFavoriteRoomOpened

	roomType: ->
		return CaoLiao.roomTypes.getTypes()

	canShowRoomType: ->
		return CaoLiao.roomTypes.checkCondition(@)

	templateName: ->
		return @template

	active: (nav)->
		if Session.get('navMenu') is nav
			return 'active'

	hasNewFriend: ->
		return friendSubscripion.findOne({"u._id": Meteor.userId()})?.unread > 0
	newFriendCount: ->
		return friendSubscripion.findOne({"u._id": Meteor.userId()})?.unread

	debatePath: ->
		return CaoLiao.tagTypes.getRouteLink @t, @

	showAdminOption: ->
		return CaoLiao.authz.hasAtLeastOnePermission( ['view-statistics', 'view-room-administration', 'view-user-administration', 'view-privileged-setting' ]) or CaoLiao.AdminBox.getOptions().length > 0

	registeredMenus: ->
		return AccountBox.getItems()

	viewOpenPermission: (name)->
		return "view-open-#{name}"

	viewPrivatePermission: (name)->
		return "view-private-#{name}"


Template.sideNav.events
	'click .side-menu': ->
		menu.close()
		
	'click .close-flex': ->
		SideNav.closeFlex()

	'click .arrow': ->
		SideNav.toggleCurrent()

	'mouseenter .header': ->
		SideNav.overArrow()

	'mouseleave .header': ->
		SideNav.leaveArrow()

	'scroll .rooms-list': ->
		menu.updateUnreadBars()

	'click .debatePreferences': ->
		Session.set('navMenu','debatePreferences')

	'click #account': (event) ->
		###
		SideNav.setFlex "accountFlex"
		SideNav.openFlex()
		###
		FlowRouter.go 'account'

	'click #admin': ->
		SideNav.setFlex "adminFlex"
		SideNav.openFlex()
		FlowRouter.go 'admin-info'

	'click #logout': (event) ->
		event.preventDefault()
		user = Meteor.user()
		FlowRouter.go 'typeDebates', {type: 'o'}
		Meteor.logout ->
			CaoLiao.callbacks.run 'afterLogoutCleanUp', user
			Meteor.call('logoutCleanUp', user, (err) ->
				console.log "arguments",arguments
				if err?
					toastr.error t 'User_not_found_or_incorrect_password'
			)
			
			


Template.sideNav.onRendered ->
	console.log "sideNav.onRendered"
	SideNav.init()
	menu.init()
	instance = this
	Meteor.defer ->
		menu.updateUnreadBars()


	instance = this
	
	interval = Meteor.setInterval ->
		if $(".collapsible")?
			$(".collapsible").collapsible()
			Meteor.clearInterval(interval)
	,100
	###
	Tracker.autorun ->	
		if instance.subscriptionsReady() && Meteor.userId() && Session.get 'materialLoaded' && $(".collapsible")?
			console.log $(".collapsible")
			$(".collapsible").collapsible()
	###

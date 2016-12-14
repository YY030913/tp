Template.accountBox.helpers

	fixCordova: (url) ->

		console.log "fixcordova"
		url = "/images/medals/#{url}.png"
		
		if Meteor.isCordova and url?[0] is '/'
			url = Meteor.absoluteUrl().replace(/\/$/, '') + url
			
		return url

	myUserInfo: ->
		visualStatus = "online"
		username = Meteor.user()?.username
		shortCountry = Meteor.user()?.shortCountry
		medals = Meteor.user()?.medals
		switch Session.get('user_' + username + '_status')
			when "away"
				visualStatus = t("away")
			when "busy"
				visualStatus = t("busy")
			when "offline"
				visualStatus = t("invisible")
		return {
			name: Session.get('user_' + username + '_name')
			status: Session.get('user_' + username + '_status')
			visualStatus: visualStatus
			_id: Meteor.userId()
			username: username
			shortCountry: shortCountry
			medals: medals
		}

	showAdminOption: ->
		return CaoLiao.authz.hasAtLeastOnePermission( ['view-statistics', 'view-room-administration', 'view-user-administration', 'view-privileged-setting' ]) or CaoLiao.AdminBox.getOptions().length > 0

	registeredMenus: ->
		return AccountBox.getItems()

Template.accountBox.events
	###
	'click .options .status': (event) ->
		event.preventDefault()
		AccountBox.setStatus(event.currentTarget.dataset.status)

	
	'click .account-box': (event) ->
		AccountBox.toggle()


	'click #logout': (event) ->
		event.preventDefault()
		user = Meteor.user()
		FlowRouter.go 'typeDebates', {type: 'o'}
		Meteor.logout ->
			CaoLiao.callbacks.run 'afterLogoutCleanUp', user
			Meteor.call('logoutCleanUp', user, (err) ->
				if err?
					toastr.error t 'User_not_found_or_incorrect_password'
			)
	

	'click #avatar': (event) ->
		FlowRouter.go 'changeAvatar'
	###

	'click #account': (event) ->
		menu.close()
		FlowRouter.go 'account'

	'click .thumb': (event) ->
		menu.close()
		FlowRouter.go 'account'

	###
	'click #admin': ->
		SideNav.setFlex "adminFlex"
		SideNav.openFlex()
		FlowRouter.go 'admin-info'

	'click .account-link': (event) ->
		event.stopPropagation();
		event.preventDefault();
		AccountBox.openFlex()

	'click .account-box-item': ->
		menu.toggle()
		# if @sideNav?
		#	SideNav.setFlex @sideNav
		#	SideNav.openFlex()
	###

Template.accountBox.onRendered ->
	AccountBox.init()

Template.adminUsers.helpers
	isReady: ->
		return Template.instance().ready?.get()
	users: ->
		return Template.instance().users()
	isLoading: ->
		return 'btn-loading' unless Template.instance().ready?.get()
	hasMore: ->
		return Template.instance().limit?.get() is Template.instance().users?().length
	flexTemplate: ->
		return CaoLiao.TabBar.getTemplate()
	flexData: ->
		return CaoLiao.TabBar.getData()
	emailAddress: ->
		return _.map(@emails, (e) -> e.address).join(', ')

Template.adminUsers.onCreated ->
	instance = @
	@limit = new ReactiveVar 50
	@filter = new ReactiveVar ''
	@ready = new ReactiveVar true

	CaoLiao.TabBar.addButton({
		groups: ['adminusers', 'adminusers-selected'],
		id: 'invite-user',
		i18nTitle: 'Invite_Users',
		icon: 'icon-paper-plane',
		template: 'adminInviteUser',
		order: 1
	})

	CaoLiao.TabBar.addButton({
		groups: ['adminusers', 'adminusers-selected'],
		id: 'add-user',
		i18nTitle: 'Add_User',
		icon: 'icon-plus',
		template: 'adminUserEdit',
		openClick: (e, t) ->
			CaoLiao.TabBar.setData()
			return true
		order: 2
	})

	CaoLiao.TabBar.addButton({
		groups: ['adminusers-selected']
		id: 'admin-user-info',
		i18nTitle: 'User_Info',
		icon: 'icon-user',
		template: 'adminUserInfo',
		order: 3
	})

	@autorun ->
		filter = instance.filter.get()
		limit = instance.limit.get()
		subscription = instance.subscribe 'fullUserData', filter, limit
		instance.ready.set subscription.ready()

	@users = ->
		filter = _.trim instance.filter?.get()
		if filter
			filterReg = new RegExp filter, "i"
			query = { $or: [ { username: filterReg }, { name: filterReg }, { "emails.address": filterReg } ] }
		else
			query = {}

		query.type =
			$in: ['user', 'bot']

		return Meteor.users.find(query, { limit: instance.limit?.get(), sort: { username: 1, name: 1 } }).fetch()

Template.adminUsers.onRendered ->
	Tracker.afterFlush ->
		SideNav.setFlex "adminFlex"
		SideNav.openFlex()

Template.adminUsers.events
	'keydown #users-filter': (e) ->
		if e.which is 13
			e.stopPropagation()
			e.preventDefault()

	'keyup #users-filter': (e, t) ->
		e.stopPropagation()
		e.preventDefault()
		t.filter.set e.currentTarget.value

	###
	'click .flex-tab .more': ->
		if CaoLiao.TabBar.isFlexOpen()
			CaoLiao.TabBar.closeFlex()
		else
			CaoLiao.TabBar.openFlex()
	###

	'click .user-info': (e) ->
		e.preventDefault()
		FlowRouter.go 'admin-userInfo', uid: @_id
		###
		CaoLiao.TabBar.setTemplate 'adminUserInfo'
		CaoLiao.TabBar.setData Meteor.users.findOne @_id
		CaoLiao.TabBar.openFlex()
		CaoLiao.TabBar.showGroup 'adminusers-selected'
		###

	'click .info-tabs button': (e) ->
		e.preventDefault()
		$('.info-tabs button').removeClass 'active'
		$(e.currentTarget).addClass 'active'

		$('.user-info-content').hide()
		$($(e.currentTarget).attr('href')).show()

	'click .load-more': (e, t) ->
		e.preventDefault()
		e.stopPropagation()
		t.limit.set t.limit.get() + 50

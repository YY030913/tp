Template.flexTabBar.helpers
	active: ->
		return 'active' if @template is CaoLiao.TabBar.getTemplate() and CaoLiao.TabBar.isFlexOpen()
	buttons: ->
		return CaoLiao.TabBar.getButtons()
	title: ->
		return t(@i18nTitle) or @title
	visible: ->
		if @groups.indexOf(CaoLiao.TabBar.getVisibleGroup()) is -1
			return 'hidden'

Template.flexTabBar.events
	'click .tab-button': (e, t) ->
		e.preventDefault()

		if CaoLiao.TabBar.isFlexOpen() and CaoLiao.TabBar.getTemplate() is @template
			CaoLiao.TabBar.closeFlex()
			$('.flex-tab').css('max-width', '')
		else
			if not @openClick? or @openClick(e,t)
				if @width?
					$('.flex-tab').css('max-width', "#{@width}px")
				else
					$('.flex-tab').css('max-width', '')

				CaoLiao.TabBar.setTemplate @template, ->
					$('.flex-tab')?.find("input[type='text']:first")?.focus()
					$('.flex-tab .content')?.scrollTop(0)

Template.flexTabBar.onCreated ->
	# close flex if the visible group changed and the opened template is not in the new visible group
	@autorun =>
		visibleGroup = CaoLiao.TabBar.getVisibleGroup()

		Tracker.nonreactive =>
			openedTemplate = CaoLiao.TabBar.getTemplate()
			exists = false
			CaoLiao.TabBar.getButtons().forEach (button) ->
				if button.groups.indexOf(visibleGroup) isnt -1 and openedTemplate is button.template
					exists = true

			unless exists
				CaoLiao.TabBar.closeFlex()

Template.pk.helpers
	fromEmail: ->
		return CaoLiao.settings.get 'From_Email'

	debatesHistory: ->
		return CaoLiao.models.Debates.find({ "flags._id": this._id}, { sort: { ts: 1 } })


Template.pk.events
	'click .send': (e, t) ->
		e.preventDefault()
		from = $(t.find('[name=from]')).val()
		subject = $(t.find('[name=subject]')).val()
		body = $(t.find('[name=body]')).val()
		dryrun = $(t.find('[name=dryrun]:checked')).val()
		query = $(t.find('[name=query]')).val()

		unless from
			toastr.error TAPi18n.__('error-invalid-from-address')
			return

		if body.indexOf('[unsubscribe]') is -1
			toastr.error TAPi18n.__('error-missing-unsubscribe-link')
			return

		Meteor.call 'Mailer.sendMail', from, subject, body, dryrun, query, (err) ->
			return handleError(err) if err
			toastr.success TAPi18n.__('The_emails_are_being_sent')
			
	'scroll .wrapper': _.throttle (e, instance) ->
		if DebatesManager.isLoading(@_id) is false and (DebatesManager.hasMore(@_id) is true or DebatesManager.hasMoreNext(@_id) is true)
			if DebatesManager.hasMore(@_id) is true and e.target.scrollTop is 0
				DebatesManager.getMore(@_id)
			else if DebatesManager.hasMoreNext(@_id) is true and e.target.scrollTop >= e.target.scrollHeight - e.target.clientHeight
				DebatesManager.getMoreNext(@_id)
	, 200

	'click .load-more > button': ->
		DebatesManager.getMore(@_id)


Template.pk.onRendered ->
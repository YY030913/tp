Template.medals.helpers
	hasPermission: ->
		return CaoLiao.authz.hasAtLeastOnePermission(['manage-tags', 'manage-own-tags'])

	tags: ->
		return Flag.find({}, { sort: { type: 1 , name: 1} })

	dateFormated: (date) ->
		return moment(date).locale(TAPi18n.getLanguage()).format('L LT')
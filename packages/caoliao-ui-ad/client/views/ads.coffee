Template.ads.helpers
	hasPermission: ->
		return CaoLiao.authz.hasAtLeastOnePermission(['manage-ads', 'manage-own-ads'])

	ads: ->
		return CaoLiao.models.Ads.find({}, { sort: { ts: 1, type: 1 , name: 1} })

	dateFormated: (date) ->
		return moment(date).locale(TAPi18n.getLanguage()).format('L LT')
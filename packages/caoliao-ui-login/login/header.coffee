Template.loginHeader.helpers
	logoUrl: ->
		asset = CaoLiao.settings.get('Assets_logo')
		if asset?
			url = asset.url or asset.defaultUrl
		if Meteor.isCordova
			url = Meteor.absoluteUrl().replace(/\/$/, '') + "/" +url
		toastr.error url
		return url
CaoLiao.authz.getRoles = ->
	return CaoLiao.models.Roles.find().fetch()

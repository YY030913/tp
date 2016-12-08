Meteor.methods
	'robot.modelCall': (model, method, args) ->
		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'robot.modelCall' }

		unless CaoLiao.authz.hasRole Meteor.userId(), 'robot'
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'robot.modelCall' }

		unless _.isFunction CaoLiao.models[model]?[method]
			throw new Meteor.Error 'error-invalid-method', 'Invalid method', { method: 'robot.modelCall' }

		call = CaoLiao.models[model][method].apply(CaoLiao.models[model], args)

		if call?.fetch?()?
			return call.fetch()
		else
			return call

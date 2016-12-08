Meteor.methods
	logged: () ->
		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'logged' }

		score = CaoLiao.models.Score.findByUserId Meteor.userId()

		scoreLogin = {}
		scoreLogin.icon = "login"
		scoreLogin.operator = "Login"

		unless score.count() > 0

			CaoLiao.models.Users.initCreateDebateCount Meteor.userId()

			CaoLiao.models.Users.setScore Meteor.userId(), 0

			activity = CaoLiao.Activity.utils.add('Register', null, 'register', 'register', null)
			activity.userId = Meteor.userId()
			CaoLiao.models.Activity.createActivity(activity)


			scoreRegister = {}
			scoreRegister.icon = "register"
			scoreRegister.operator = "Register"
			scoreRegister.userId = Meteor.userId()
			scoreRegister.score = CaoLiao.Score.utils.registerScore
			CaoLiao.models.Score.create(scoreRegister)

		current = new Date()
		today = "#{current.getFullYear()} - #{current.getMonth() + 1} - #{current.getDate()}"
		todayLogged = CaoLiao.models.Score.findByUserId Meteor.userId(), {"operator": 'Login', "ts": $gt : new Date(today)}

		unless todayLogged.count() > 0
			scoreLogin.userId = Meteor.userId()
			scoreLogin.score = CaoLiao.Score.utils.loginScore
			CaoLiao.models.Score.create(scoreLogin)
		return true

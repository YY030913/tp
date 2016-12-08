Meteor.methods
	cancelFollow: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'cancelFollow' }

		if CaoLiao.authz.hasPermission(user._id, 'update-follow') isnt true
			throw new Meteor.Error 'update-follow', "Not allowed", { method: 'cancelFollow' }

		now = new Date()

		option = {
			name: 1
		}

		friend = CaoLiao.models.Users.findOneById _id, option

		if not friend
			throw new Meteor.Error 'update-follow', "user not exist", { method: 'cancelFollow' }
		data = {
			u:
				_id: user._id
				name: user.username
			friend:
				_id: _id
				name: friend.username
		}

		follow = CaoLiao.models.Friend.findByOne user._id, _id
		
		if not follow
			throw new Meteor.Error 'update-follow', "user not follow", { method: 'cancelFollow' }
		else
			CaoLiao.models.Friend.delFriend user._id, _id
		
		Member = []
		Member.push(_id)
		CaoLiao.models.FriendsSubscriptions.incUnreadForUserIds Member, -1

		activity = CaoLiao.Activity.utils.add(friend.name, "", 'cancel_follow', 'Cancel_Follow', "/user/profile/#{friend._id}")
		activity.userId = Meteor.userId()
		CaoLiao.models.Activity.createActivity(activity)

		# score = CaoLiao.Score.utils.add("/user/profile/#{friend._id}", 'cancel_follow', 'Cancel_Follow')
		# CaoLiao.models.Score.update(Meteor.userId(), score, CaoLiao.Score.utils.addFollow)

		CaoLiao.callbacks.run 'afterCancelFollow', data
		return true
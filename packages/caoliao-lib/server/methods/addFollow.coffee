Meteor.methods
	addFollow: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'addFollow' }

		if CaoLiao.authz.hasPermission(user._id, 'update-follow') isnt true
			throw new Meteor.Error 'update-follow', "Not allowed", { method: 'addFollow' }

		now = new Date()

		option = {
			name: 1
			pinyin: 1
		}

		friend = CaoLiao.models.Users.findOneById _id, option

		if not friend
			throw new Meteor.Error 'update-follow', "user not exist", { method: 'addFollow' }


		data = {
			u:
				_id: user._id
				name: user.username
				pinyin: user.pinyin
			friend:
				_id: _id
				name: friend.username
				pinyin: friend.pinyin
		}

		follow = CaoLiao.models.Friend.findByOne user._id, _id
		
		if not follow
			follow = CaoLiao.models.Friend.findByOneDel user._id, _id
			if not follow
				CaoLiao.models.Friend.createFriend data
			CaoLiao.models.Friend.refollowFriend user._id, _id

		Member = []
		Member.push(_id)

		CaoLiao.models.FriendsSubscriptions.incUnreadForUserIds Member

		activity = CaoLiao.Activity.utils.add(friend.name, "", 'add_follow', 'Add_Follow', "/user/profile/#{friend._id}")
		activity.userId = Meteor.userId()
		CaoLiao.models.Activity.createActivity(activity)

		# score = CaoLiao.Score.utils.add("/user/profile/#{friend._id}", 'add_follow', 'Add_Follow')
		# CaoLiao.models.Score.update(Meteor.userId(), score, CaoLiao.Score.utils.addFollow)

		CaoLiao.callbacks.run 'afterAddFollow', data
		return true
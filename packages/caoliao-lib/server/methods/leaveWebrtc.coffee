Meteor.methods
	leaveWebrtc: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'leaveWebrtc' }

		option = {
			name: 1
		}

		room = CaoLiao.models.Rooms.findOne({_id: _id})

		if room.did?
			debate = CaoLiao.models.Debates.findOne {_id: room.did}
		
			if debate?
				joined = CaoLiao.models.Debates.findOne({_id: room.did, "webrtcJoined._id": user._id})

				if joined?
					CaoLiao.models.Debates.pullWebrtcJoined room.did, {_id: user._id}

		if room?
			if CaoLiao.models.Rooms.findOne({_id: _id, "left._id": user._id})?
				CaoLiao.models.Rooms.removeLeftById _id, {_id: user._id}
				
			if CaoLiao.models.Rooms.findOne({_id: _id, "right._id": user._id})?
				CaoLiao.models.Rooms.removeRightById _id, {_id: user._id}

		return true
Meteor.methods
	joinWebrtc: (_id, direction=null) ->
		
		user = Meteor.user()


		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'joinWebrtc' }

		if CaoLiao.authz.hasPermission(user._id, 'webrtc-join') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'joinWebrtc' }

		if direction=="left" || direction=="right"

			option = {
				name: 1
			}

			room = CaoLiao.models.Rooms.findOne({_id: _id})

			if room.did?
				
				debate = CaoLiao.models.Debates.findOne {_id: room.did}
			
				if debate?
					joined = CaoLiao.models.Debates.findOne({_id: room.did, "webrtcJoined._id": user._id})

					if !joined?
						CaoLiao.models.Debates.pushWebrtcJoined room.did, {_id: user._id}

			if room?
				
				if direction? && direction == "left"
					CaoLiao.models.Rooms.addLeftById _id, {_id: user._id}
				if direction? && direction == "right"
					CaoLiao.models.Rooms.addRightById _id, {_id: user._id}

			return true
		else
			throw new Meteor.Error 'error-not-allowed', "error dirction", { method: 'joinWebrtc' }
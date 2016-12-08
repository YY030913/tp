Meteor.methods
	setUserLocation: (latLng) ->
		active = false;
		if latLng?.lat? && latLng?.lng? && active
			try
				geo = new GeoCoder()
				geoCoder = geo.reverse(latLng.lat, latLng.lng)

				if not Meteor.userId()
					throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'setUserLocation' }

				user = CaoLiao.models.Users.findOneById Meteor.userId()
				#if user and user.requirePasswordChange isnt true
				#	throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'setUserLocation' }

				if user?

					latBol = true;
					lngBol = true;
					
					if user.latLng?

						latBol = Math.abs(user.latLng[user.latLng.length - 1].lat - latLng.lat) > 0.01

						lngBol = Math.abs(user.latLng[user.latLng.length - 1].lng - latLng.lng) > 0.01

					if latBol or lngBol
						count = CaoLiao.models.Users.update {
								_id: Meteor.userId()
							},
							{
								$push: 
									latLng: latLng
									geoCoder: geoCoder
							}
			catch e
				console.log e
				return 
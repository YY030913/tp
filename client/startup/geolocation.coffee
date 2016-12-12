Tracker.autorun ->
	if Meteor.user()
		user = Meteor.user()
		Meteor.call("setUserLocation", Geolocation.latLng())
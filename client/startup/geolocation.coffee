Tracker.autorun ->
	user = Meteor.user()
	Meteor.call("setUserLocation", Geolocation.latLng())
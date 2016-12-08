Meteor.startup ->
	InstanceStatus.registerInstance('caoliao', {port: process.env.PORT})
	# InstanceStatus.activeLogs()
	UserPresence.start()
	# UserPresence.activeLogs()
	UserPresenceMonitor.start()

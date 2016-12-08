###
Meteor.startup ->
	if Meteor.isCordova
		WebAppLocalServer.localFileSystemUrl();
###
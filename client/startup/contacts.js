Meteor.startup(function() {
	if(Meteor.isCordova) {
		console.log(navigator.contacts);
		Tracker.autorun(function() {
			function onSuccess(contacts) {
				console.log('Found ' + contacts.length + ' contacts.');
			};
			 
			function onError(contactError) {
				console.log('onError!');
			};
			 
			var options	= new ContactFindOptions();
			options.filter = "Bob";
			options.multiple = true;
			options.desiredFields = [navigator.contacts.fieldType.id];
			options.hasPhoneNumber = true;

			var fields = [navigator.contacts.fieldType.displayName, navigator.contacts.fieldType.name];
			navigator.contacts.find(fields, onSuccess, onError, options);
		});
	}
	
});
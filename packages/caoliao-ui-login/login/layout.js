Template.loginLayout.onRendered(function() {
	$('#initial-page-loading').remove();
});

Template.loginLayout.helpers({
	fixCordovaBg: function() {
		url = "/images/full-bg.jpeg";

		if (Meteor.isCordova) {
			url = Meteor.absoluteUrl().replace(/\/$/, '') + url
		}
		toastr.error(url);
		return url
	}
});
Meteor.methods
	testAccount: (serviceData, options) ->
		console.log HTTP.get("https://api.weibo.com/2/account/profile/email.json",{params: {access_token: "2.00JhcG1GFriXdB0f27c5a55eHOWicB"}}).data
		Accounts.updateOrCreateUserFromExternalService("weibo", serviceData, options)

/* globals CaoLiao */
CaoLiao.SMS = {
	enabled: false,
	services: {},
	accountSid: null,
	authToken: null,
	fromNumber: null,

	registerService(name, service) {
		this.services[name] = service;
	},

	getService(name) {
		if (!this.services[name]) {
			throw new Meteor.Error('error-sms-service-not-configured');
		}
		return new this.services[name](this.accountSid, this.authToken, this.fromNumber);
	}
};

CaoLiao.settings.get('SMS_Enabled', function(key, value) {
	CaoLiao.SMS.enabled = value;
});

Meteor.startup(function() {
	Tracker.autorun(function() {
		if (CaoLiao.settings.get('OTR_Enable') && window.crypto) {
			CaoLiao.OTR.crypto = window.crypto.subtle || window.crypto.webkitSubtle;
			CaoLiao.OTR.enabled.set(true);
			CaoLiao.TabBar.addButton({
				groups: ['directmessage'],
				id: 'otr',
				i18nTitle: 'OTR',
				icon: 'icon-key',
				template: 'otrFlexTab',
				order: 11
			});
		} else {
			CaoLiao.OTR.enabled.set(false);
			CaoLiao.TabBar.removeButton('otr');
		}
	});
});

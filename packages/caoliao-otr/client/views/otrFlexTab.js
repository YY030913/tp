Template.otrFlexTab.helpers({
	otrAvailable() {
		return CaoLiao.OTR && CaoLiao.OTR.isEnabled();
	},
	userIsOnline() {
		// I have to appear online for the other user
		if (Meteor.user().status === 'offline') {
			return false;
		}

		if (this.rid) {
			const peerId = this.rid.replace(Meteor.userId(), '');
			if (peerId) {
				const user = Meteor.users.findOne(peerId);
				const online = user && user.status !== 'offline';
				return online;
			}
		}
	},
	established() {
		const otr = CaoLiao.OTR.getInstanceByRoomId(this.rid);
		return otr && otr.established.get();
	},
	establishing() {
		const otr = CaoLiao.OTR.getInstanceByRoomId(this.rid);
		return otr && otr.establishing.get();
	}
});

Template.otrFlexTab.events({
	'click button.start': function(e, t) {
		e.preventDefault();
		const otr = CaoLiao.OTR.getInstanceByRoomId(this.rid);
		if (otr) {
			otr.handshake();
			t.timeout = Meteor.setTimeout(() => {
				swal('Timeout', '', 'error');
				otr.establishing.set(false);
			}, 10000);
		}
	},
	'click button.refresh': function(e, t) {
		e.preventDefault();
		const otr = CaoLiao.OTR.getInstanceByRoomId(this.rid);
		if (otr) {
			otr.reset();
			otr.handshake(true);
			t.timeout = Meteor.setTimeout(() => {
				swal('Timeout', '', 'error');
				otr.establishing.set(false);
			}, 10000);
		}
	},
	'click button.end': function(e/*, t*/) {
		e.preventDefault();
		const otr = CaoLiao.OTR.getInstanceByRoomId(this.rid);
		if (otr) {
			otr.end();
		}
	}
});

Template.otrFlexTab.onCreated(function() {
	this.timeout = null;
	this.autorun(() => {
		const otr = CaoLiao.OTR.getInstanceByRoomId(this.data.rid);
		if (otr && otr.established.get()) {
			Meteor.clearTimeout(this.timeout);
		}
	});
});

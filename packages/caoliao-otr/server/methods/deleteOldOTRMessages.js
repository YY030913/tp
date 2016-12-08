Meteor.methods({
	deleteOldOTRMessages: function(roomId) {
		if (!Meteor.userId()) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'deleteOldOTRMessages' });
		}

		const now = new Date();
		const subscription = CaoLiao.models.Subscriptions.findOneByRoomIdAndUserId(roomId, Meteor.userId());
		if (subscription && subscription.t === 'd') {
			CaoLiao.models.Messages.deleteOldOTRMessages(roomId, now);
		} else {
			throw new Meteor.Error('error-invalid-room', 'Invalid room', { method: 'deleteOldOTRMessages' });
		}
	}
});

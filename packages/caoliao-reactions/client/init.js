Template.room.events({
	'click .add-reaction'(event) {
		event.preventDefault();
		event.stopPropagation();
		const data = Blaze.getData(event.currentTarget);

		let user = Meteor.user();
		let room = CaoLiao.models.Rooms.findOne({ _id: data._arguments[1].rid });

		if (Array.isArray(room.muted) && room.muted.indexOf(user.username) !== -1) {
			return false;
		}

		CaoLiao.EmojiPicker.open(event.currentTarget, (emoji) => {
			Meteor.call('setReaction', ':' + emoji + ':', data._arguments[1]._id);
		});
	},

	'click .reactions > li:not(.add-reaction)'(event) {
		event.preventDefault();
		const data = Blaze.getData(event.currentTarget);
		Meteor.call('setReaction', $(event.currentTarget).data('emoji'), data._arguments[1]._id, () => {
			CaoLiao.tooltip.hide();
		});
	},

	'mouseenter .reactions > li:not(.add-reaction)'(event) {
		event.stopPropagation();
		CaoLiao.tooltip.showElement($(event.currentTarget).find('.people').get(0), event.currentTarget);
	},

	'mouseleave .reactions > li:not(.add-reaction)'(event) {
		event.stopPropagation();
		CaoLiao.tooltip.hide();
	}
});

Meteor.startup(function() {
	// CaoLiao.MessageAction.addButton({
	// 	id: 'reaction-message',
	// 	icon: 'icon-people-plus',
	// 	i18nLabel: 'Reactions',
	// 	context: [
	// 		'message',
	// 		'message-mobile'
	// 	],
	// 	action(event) {
	// 		const data = Blaze.getData(event.currentTarget);

	// 		event.stopPropagation();

	// 		CaoLiao.EmojiPicker.open(event.currentTarget, (emoji) => {
	// 			Meteor.call('setReaction', ':' + emoji + ':', data._arguments[1]._id);
	// 		});
	// 	},
	// 	validation(message) {
	// 		let room = CaoLiao.models.Rooms.findOne({ _id: message.rid });
	// 		let user = Meteor.user();

	// 		if (Array.isArray(room.muted) && room.muted.indexOf(user.username) !== -1) {
	// 			return false;
	// 		} else if (Array.isArray(room.usernames) && room.usernames.indexOf(user.username) === -1) {
	// 			return false;
	// 		}

	// 		return true;
	// 	},
	// 	order: 22
	// });
});

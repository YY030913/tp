/* globals CaoLiao */
CaoLiao.deleteUser = function(userId) {
	const user = CaoLiao.models.Users.findOneById(userId);

	CaoLiao.models.Messages.removeByUserId(userId); // Remove user messages
	CaoLiao.models.Subscriptions.findByUserId(userId).forEach((subscription) => {
		let room = CaoLiao.models.Rooms.findOneById(subscription.rid);
		if (room) {
			if (room.t !== 'c' && room.usernames.length === 1) {
				CaoLiao.models.Rooms.removeById(subscription.rid); // Remove non-channel rooms with only 1 user (the one being deleted)
			}
			if (room.t === 'd') {
				CaoLiao.models.Subscriptions.removeByRoomId(subscription.rid);
				CaoLiao.models.Messages.removeByRoomId(subscription.rid);
			}
		}
	});

	CaoLiao.models.Subscriptions.removeByUserId(userId); // Remove user subscriptions
	CaoLiao.models.Rooms.removeByTypeContainingUsername('d', user.username); // Remove direct rooms with the user
	CaoLiao.models.Rooms.removeUsernameFromAll(user.username); // Remove user from all other rooms

	// removes user's avatar
	if (user.avatarOrigin === 'upload' || user.avatarOrigin === 'url') {
		CaoLiaoFileAvatarInstance.deleteFile(encodeURIComponent(user.username + '.jpg'));
	}

	CaoLiao.models.Users.removeById(userId); // Remove user from users database
};

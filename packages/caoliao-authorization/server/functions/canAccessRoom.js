/* globals CaoLiao */
CaoLiao.authz.roomAccessValidators = [
	function(room, user) {
		return room.usernames.indexOf(user.username) !== -1;
	},
	function(room, user) {
		if (room.t === 'c') {
			return CaoLiao.authz.hasPermission(user._id, 'view-c-room');
		}
	}
];

CaoLiao.authz.canAccessRoom = function(room, user) {
	return CaoLiao.authz.roomAccessValidators.some((validator) => {
		return validator.call(this, room, user);
	});
};

CaoLiao.authz.addRoomAccessValidator = function(validator) {
	CaoLiao.authz.roomAccessValidators.push(validator);
};

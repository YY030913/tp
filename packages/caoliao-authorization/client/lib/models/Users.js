Meteor.subscribe('scopedRoles', 'Users');

if (_.isUndefined(CaoLiao.models.Users)) {
	CaoLiao.models.Users = {};
}

CaoLiao.models.Users.isUserInRole = function(userId, roleName) {
	var query = {
		_id: userId,
		roles: roleName
	};

	return !_.isUndefined(this.findOne(query));
};

CaoLiao.models.Users.findUsersInRoles = function(roles, scope, options) {
	roles = [].concat(roles);

	var query = {
		roles: { $in: roles }
	};

	return this.find(query, options);
};

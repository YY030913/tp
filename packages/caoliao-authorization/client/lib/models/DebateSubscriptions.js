Meteor.subscribe('scopedRoles', 'DebateDebateSubscriptions');

if (_.isUndefined(CaoLiao.models.DebateSubscriptions)) {
	CaoLiao.models.DebateSubscriptions = {};
}

CaoLiao.models.DebateSubscriptions.isUserInRole = function(userid, roleName, tid) {
	var query = {
		tid: tid,
		roles: roleName
	};

	return !_.isUndefined(this.findOne(query));
};

CaoLiao.models.DebateSubscriptions.findUsersInRoles = function(roles, scope, options) {
	roles = [].concat(roles);

	var query = {
		roles: { $in: roles }
	};

	if (scope) {
		query.tid = scope;
	}

	var debateSubscriptions = this.find(query).fetch();

	var users = _.compact(_.map(debateSubscriptions, function(subscription) {
		if ('undefined' !== typeof subscription.u && 'undefined' !== typeof subscription.u._id) {
			return subscription.u._id;
		}
	}));

	return CaoLiao.models.Users.find({ _id: { $in: users } }, options);
};

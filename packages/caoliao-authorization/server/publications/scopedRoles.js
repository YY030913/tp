/**
 * Publish logged-in user's roles so client-side checks can work.
 */
Meteor.publish('scopedRoles', function(scope) {
	if (!this.userId || _.isUndefined(CaoLiao.models[scope]) || !_.isFunction(CaoLiao.models[scope].findRolesByUserId)) {
		this.ready();
		return;
	}

	return CaoLiao.models[scope].findRolesByUserId(this.userId);
});

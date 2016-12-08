/* globals CaoLiao */
CaoLiao.authz.tagAccessValidators = [
	function(tag, user) {
		return (CaoLiao.models.Tags.findOneByMemeberAndTag(user, tag) != null);
	},
	function(tag, user) {
		if (tag.t === 'o') {
			return CaoLiao.authz.hasPermission(user._id, 'view-o-tag');
		}
	}
];

CaoLiao.authz.canAccessTag = function(tag, user) {
	return CaoLiao.authz.tagAccessValidators.some((validator) => {
		return validator.call(this, tag, user);
	});
};

CaoLiao.authz.addTagAccessValidator = function(validator) {
	CaoLiao.authz.tagAccessValidators.push(validator);
};

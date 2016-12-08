/**
 * Gets visitor by token
 * @param {string} token - Visitor token
 */
CaoLiao.models.Rooms.updateSurveyFeedbackById = function(_id, surveyFeedback) {
	const query = {
		_id: _id
	};

	const update = {
		$set: {
			surveyFeedback: surveyFeedback
		}
	};

	return this.update(query, update);
};

CaoLiao.models.Rooms.updateLivechatDataByToken = function(token, key, value) {
	const query = {
		'v.token': token
	};

	const update = {
		$set: {
			[`livechatData.${key}`]: value
		}
	};

	return this.upsert(query, update);
};

CaoLiao.models.Rooms.findLivechat = function(offset = 0, limit = 20) {
	const query = {
		t: 'l'
	};

	return this.find(query, { sort: { ts: - 1 }, offset: offset, limit: limit });
};

CaoLiao.models.Rooms.findLivechatByCode = function(code, fields) {
	const query = {
		t: 'l',
		code: parseInt(code)
	};

	let options = {};

	if (fields) {
		options.fields = fields;
	}

	return this.find(query, options);
};

/**
 * Get the next visitor name
 * @return {string} The next visitor name
 */
CaoLiao.models.Rooms.getNextLivechatRoomCode = function() {
	const settingsRaw = CaoLiao.models.Settings.model.rawCollection();
	const findAndModify = Meteor.wrapAsync(settingsRaw.findAndModify, settingsRaw);

	const query = {
		_id: 'Livechat_Room_Count'
	};

	const update = {
		$inc: {
			value: 1
		}
	};

	const livechatCount = findAndModify(query, null, update);

	return livechatCount.value;
};

CaoLiao.models.Rooms.findOpenByVisitorToken = function(visitorToken, options) {
	const query = {
		open: true,
		'v.token': visitorToken
	};

	return this.find(query, options);
};

CaoLiao.models.Rooms.findByVisitorToken = function(visitorToken) {
	const query = {
		'v.token': visitorToken
	};

	return this.find(query);
};

CaoLiao.models.Rooms.findByVisitorId = function(visitorId) {
	const query = {
		'v._id': visitorId
	};

	return this.find(query);
};

CaoLiao.models.Rooms.closeByRoomId = function(roomId) {
	return this.update({ _id: roomId }, { $unset: { open: 1 } });
};

CaoLiao.models.Rooms.setLabelByRoomId = function(roomId, label) {
	return this.update({ _id: roomId }, { $set: { label: label } });
};

CaoLiao.Livechat = {
	getNextAgent(department) {
		if (department) {
			return CaoLiao.models.LivechatDepartmentAgents.getNextAgentForDepartment(department);
		} else {
			return CaoLiao.models.Users.getNextAgent();
		}
	},
	sendMessage({ guest, message, roomInfo }) {
		var room = CaoLiao.models.Rooms.findOneById(message.rid);
		var newRoom = false;

		if (room && !room.open) {
			message.rid = Random.id();
			room = null;
		}

		if (room == null) {

			// if no department selected verify if there is only one active and use it
			if (!guest.department) {
				var departments = CaoLiao.models.LivechatDepartment.findEnabledWithAgents();
				if (departments.count() === 1) {
					guest.department = departments.fetch()[0]._id;
				}
			}

			const agent = CaoLiao.Livechat.getNextAgent(guest.department);
			if (!agent) {
				throw new Meteor.Error('no-agent-online', 'Sorry, no online agents');
			}

			const roomCode = CaoLiao.models.Rooms.getNextLivechatRoomCode();

			room = _.extend({
				_id: message.rid,
				msgs: 1,
				lm: new Date(),
				code: roomCode,
				label: guest.name || guest.username,
				usernames: [agent.username, guest.username],
				t: 'l',
				ts: new Date(),
				v: {
					_id: guest._id,
					token: message.token
				},
				open: true
			}, roomInfo);
			let subscriptionData = {
				rid: message.rid,
				name: guest.name || guest.username,
				alert: true,
				open: true,
				unread: 1,
				answered: false,
				code: roomCode,
				u: {
					_id: agent.agentId,
					username: agent.username
				},
				t: 'l',
				desktopNotifications: 'all',
				mobilePushNotifications: 'all',
				emailNotifications: 'all'
			};

			CaoLiao.models.Rooms.insert(room);
			CaoLiao.models.Subscriptions.insert(subscriptionData);

			newRoom = true;
		} else {
			room = Meteor.call('canAccessRoom', message.rid, guest._id);
		}
		if (!room) {
			throw new Meteor.Error('cannot-acess-room');
		}
		return _.extend(CaoLiao.sendMessage(guest, message, room), { newRoom: newRoom });
	},
	registerGuest({ token, name, email, department, phone, loginToken, username } = {}) {
		check(token, String);

		const user = CaoLiao.models.Users.getVisitorByToken(token, { fields: { _id: 1 } });

		if (user) {
			throw new Meteor.Error('token-already-exists', 'Token already exists');
		}

		if (!username) {
			username = CaoLiao.models.Users.getNextVisitorUsername();
		}

		let updateUser = {
			$set: {
				profile: {
					guest: true,
					token: token
				}
			}
		};

		var existingUser = null;

		var userId;

		if (s.trim(email) !== '' && (existingUser = CaoLiao.models.Users.findOneByEmailAddress(email))) {
			if (existingUser.type !== 'visitor') {
				throw new Meteor.Error('error-invalid-user', 'This email belongs to a registered user.');
			}

			updateUser.$addToSet = {
				globalRoles: 'livechat-guest'
			};

			if (loginToken) {
				updateUser.$addToSet['services.resume.loginTokens'] = loginToken;
			}

			userId = existingUser._id;
		} else {
			updateUser.$set.name = name;

			var userData = {
				username: username,
				globalRoles: ['livechat-guest'],
				department: department,
				type: 'visitor'
			};

			if (this.connection) {
				userData.userAgent = this.connection.httpHeaders['user-agent'];
				userData.ip = this.connection.httpHeaders['x-real-ip'] || this.connection.clientAddress;
				userData.host = this.connection.httpHeaders.host;
			}

			userId = Accounts.insertUserDoc({}, userData);

			if (loginToken) {
				updateUser.$set.services = {
					resume: {
						loginTokens: [ loginToken ]
					}
				};
			}
		}

		if (phone) {
			updateUser.$set.phone = [
				{ phoneNumber: phone.number }
			];
		}

		if (email && email.trim() !== '') {
			updateUser.$set.emails = [
				{ address: email }
			];
		}

		Meteor.users.update(userId, updateUser);

		return userId;
	},

	saveGuest({ _id, name, email, phone }) {
		let updateData = {};

		if (name) {
			updateData.name = name;
		}
		if (email) {
			updateData.email = email;
		}
		if (phone) {
			updateData.phone = phone;
		}
		return CaoLiao.models.Users.saveUserById(_id, updateData);
	},

	closeRoom({ user, room, comment }) {
		CaoLiao.models.Rooms.closeByRoomId(room._id);

		const message = {
			t: 'livechat-close',
			msg: comment,
			groupable: false
		};

		CaoLiao.sendMessage(user, message, room);

		CaoLiao.models.Subscriptions.hideByRoomIdAndUserId(room._id, user._id);

		return true;
	},

	getInitSettings() {
		let settings = {};

		CaoLiao.models.Settings.findNotHiddenPublic([
			'Livechat_title',
			'Livechat_title_color',
			'Livechat_enabled',
			'Livechat_registration_form',
			'Livechat_offline_title',
			'Livechat_offline_title_color',
			'Livechat_offline_message'
		]).forEach((setting) => {
			settings[setting._id] = setting.value;
		});

		return settings;
	},

	saveRoomInfo(roomData, guestData) {
		if (!CaoLiao.models.Rooms.saveRoomById(roomData._id, roomData)) {
			return false;
		}

		if (!_.isEmpty(guestData.name)) {
			return CaoLiao.models.Rooms.setLabelByRoomId(roomData._id, guestData.name) && CaoLiao.models.Subscriptions.updateNameByRoomId(roomData._id, guestData.name);
		}
	}
};

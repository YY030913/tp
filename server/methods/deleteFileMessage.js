Meteor.methods({
	deleteFileMessage: function(fileID) {
		return Meteor.call('deleteMessage', CaoLiao.models.Messages.getMessageByFileId(fileID));
	}
});

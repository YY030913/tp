@Follow = new Meteor.Collection "caoliao_follow" 

CaoLiao.models.Follow = _.extend {}, @Follow

@ProfileUsers = new Meteor.Collection "profile-users"
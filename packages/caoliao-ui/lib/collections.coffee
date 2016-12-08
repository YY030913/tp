@ChatMessage = new Meteor.Collection null

@SearchDebatesResult = new Meteor.Collection null
@SearchUsersResult = new Meteor.Collection null

@ChatRoom = new Meteor.Collection 'caoliao_room'
@Tag = new Meteor.Collection 'caoliao_tag'
@Ad = new Meteor.Collection 'caoliao_ad'
@friendSubscripion = new Meteor.Collection 'caoliao_friend_subscription'
CaoLiao.models.Searchs = new Meteor.Collection 'caoliao_searchs'

@ChatSubscription = new Meteor.Collection 'caoliao_subscription'
@UserRoles = new Mongo.Collection null
@RoomRoles = new Mongo.Collection null
@UserAndRoom = new Meteor.Collection null
@CachedChannelList = new Meteor.Collection null

CaoLiao.models.Users = _.extend {}, CaoLiao.models.Users, Meteor.users
CaoLiao.models.Subscriptions = _.extend {}, CaoLiao.models.Subscriptions, @ChatSubscription
CaoLiao.models.Rooms = _.extend {}, CaoLiao.models.Rooms, @ChatRoom
CaoLiao.models.Messages = _.extend {}, CaoLiao.models.Messages, @ChatMessage
CaoLiao.models.Tags = _.extend {}, CaoLiao.models.Tags, @Tag
CaoLiao.models.Ads = _.extend {}, CaoLiao.models.Ads, @Ad

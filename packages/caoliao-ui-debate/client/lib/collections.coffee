@Debate = new Meteor.Collection "caoliao_debate_pub" 
@Debates = new Meteor.Collection null
@DebateSubscription = new Meteor.Collection 'caoliao_debate_subscription'

CaoLiao.models.Debate = _.extend {}, @Debate
CaoLiao.models.Debates = _.extend {}, @Debates
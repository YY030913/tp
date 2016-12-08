messages
client->server
caoliao-ui:template.messagebox.events->keydown .input-message(chatmessages.keydown)
caoliao-lib:chatMessages->keydown->send(meteor.call sendMessage)--promise && fliter && notification
caoliao-lib:server-methods->sendmessage->CaoLiao.sendMessage
caoliao-lib:server-functions->sendmessage->upsert && callback


caoliao-subscription关联了用户和房间的publish，push情况


server->client

view:rocket-ui:view-room.html webRTC unread ChatSubscription ChatMessage
(根据message的ts时间创建消息时间，和用户离开时间确定是否unread 代码参考rocket-ui:lib->roommanager.coffee)
roommanager通过dom加载tempalte.room,使用blaze渲染到room模板Blaze._TemplateWith
openroom通过meteor.defer(setInterval)调用加载subscription和roommanager
client中通过startup的deafaultRoomTypes进行路由
caoliao单独写的room路由类rocket-lib:CaoLiao.roomTypes 对flowrouter进行封装


meteor npm install --save react react-addons-pure-render-mixin react-tap-event-plugin bowser material-ui radium react-router moment react-addons-css-transition-group react-scroll-components react-tagsinput url-join react-dom

meteor npm install --save fibers

electron: npm install

meteor npm install --save react-tap-event-plugin bowser

meteor npm install --save react 

meteor run android-device --mobile-server=https://caoliao.net.cn


winodws 
create system env value
MONGO_URL
mongodb://caoliao:123456@ds029456.mlab.com:29456/caoliao


添加flag，所有用户也要重新添加debatesubscription

meteor

  "electron": {
    "autoPackage": true,
    "builds": [{
      "platform": "darwin", "arch": "x64"
    },{
      "platform": "win32", "arch": "ia32"
    }],
    "downloadUrls": {
      "win32": "/public/downloads/win32/",
      "darwin": "/public/downloads/osx/"
    },
    "name": "caoliao",
    "rootUrl": "https://caoliao.net.cn/",
    "version": "0.0.1",
    "description": "caoliao app",
    "frame": true,
    "title-bar-style": "hidden",
    "resizable": true,
    "protocols": [{
      "name": "caoliao",
      "schemes": ["caoliao"]
    }]
  }
CaoLiao.utils = {};

/////////////////////////////
// String Helper Functions //
/////////////////////////////

CaoLiao.utils.cleanUp = function(s) {
  return this.stripHTML(s);
};

CaoLiao.utils.sanitize = function(s) {
  // console.log('// before sanitization:')
  // console.log(s)
  if(Meteor.isServer){
    s = sanitizeHtml(s, {
      allowedTags: [
        'h3', 'h4', 'h5', 'h6', 'blockquote', 'p', 'a', 'ul',
        'ol', 'nl', 'li', 'b', 'i', 'strong', 'em', 'strike',
        'code', 'hr', 'br', 'div', 'table', 'thead', 'caption',
        'tbody', 'tr', 'th', 'td', 'pre', 'img'
      ]
    });
    // console.log('// after sanitization:')
    // console.log(s)
  }
  return s;
};

CaoLiao.utils.stripImgSrcs = function(s) {
    imgarr = s.match(/<img(?:.|\n)*?>/gm, '');
    var srcs = [];
    for(index in imgarr) {
      srcs.push(imgarr[index].match(/src=[\'\"]?([^\'\"]*)[\'\"]?/i)[1]);
    }
  return srcs;
};

CaoLiao.utils.extendImgSrcs = function(s, extend) {
    return s.replace(/<img src=[\'\"]?([^\'\"]*)[\'\"](?:.|\n)*?>?/igm,function(word){
      return word.substring(0, word.length-1)+extend+word.substring(word.length-1);
    });
};

CaoLiao.utils.extendRemoveImgSrcs = function(s) {
  return s.replace(/<img src=[\'\"]?([^\'\"]*)[\'\"](?:.|\n)*?>?/igm,function(word){
    return word.substring(0, word.indexOf("?"))+word.substring(word.length-1);}
  )
}

CaoLiao.utils.stripTextInside = function(s) {
    if(!!s) {
      textarr = s.match(/(\t|\n|  )*?>/gm, '');
      return textarr;
    }
    return null;
};

CaoLiao.utils.stripHTML = function(s) {
  return s.replace(/<(?:.|\n)*?>/gm, '').trim();
};

CaoLiao.utils.stripMarkdown = function(s) {
  var htmlBody = marked(s);
  return CaoLiao.utils.stripHTML(htmlBody);
};

// http://stackoverflow.com/questions/2631001/javascript-test-for-existence-of-nested-object-key
CaoLiao.utils.checkNested = function(obj /*, level1, level2, ... levelN*/) {
  var args = Array.prototype.slice.call(arguments);
  obj = args.shift();

  for (var i = 0; i < args.length; i++) {
    if (!obj.hasOwnProperty(args[i])) {
      return false;
    }
    obj = obj[args[i]];
  }
  return true;
};

CaoLiao.log = function (s) {
  if(Settings.get('debug', false) || process.env.NODE_ENV === "development") {
    console.log(s);
  }
};

// see http://stackoverflow.com/questions/8051975/access-object-child-properties-using-a-dot-notation-string
CaoLiao.getNestedProperty = function (obj, desc) {
  var arr = desc.split(".");
  while(arr.length && (obj = obj[arr.shift()]));
  return obj;
};
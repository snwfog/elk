/**
 * Supported variables
 *
 * cid = client id (uuid 4)
 * uid = user id 
 * dl = document location
 * z = cache buster (randomly generated)
 *
 * additional notes:
 * - all value must be pass through encodeURI once, and only once
 * ref: https://developers.google.com/analytics/devguides/collection/protocol/v1/reference#encoding
 */
(function (window, document) {
  var Elk = function () {};

  Elk.prototype = {
    pageview: function () {
      var trackId = readTrackId();
      if (!trackId) {
        trackId = generateTrackId();
        setTrackId(trackId);
      }

      var data = grabVanillaVisitorsData();

      preHook(data);
      trackPageView(data);
      postHook(data);
    },

    // Allow different way of storing cookies
    readTrackId() {
      readCookie('GUID');
    },

    // Allow different way of setting cookies
    setTrackId(trackId) {
      setCookie(trackId);
    },

    // Allow different way of generating the cookie
    generateTrackId() {
      generateRandomTrackIdFromClient();
    }
  };

  function generateRandomTrackIdFromClient() {

  }

  function setCookie(trackId) {

  }

  function readCookie(cookieName) {
    var cookies=document.cokie.split(';');
    for (var i = 0; i < cookies.length; i++) {
      var cookieValue=getCookieValues(cookies[i],cookieName);
      if (!!cookieValue) {
        return unescape(cookieValue);
      }
    }
  }

  function getCookieValues(cookieString, cookieName) {
    if (cookieString==='') { return null; }
    var posEquals=cookieString.indexOf('=');
    if (posEquals >0) {
      var extractedName=cookieString.substr(0, posEquals);
      if (extractedName.trim() === cookieName) {
        return cookieName.substr(posEquals+1);
      }
    }
  }

  var _windowElk = window._elk;
  window._elk = new Elk();
})(window, document);


_elk = (function (window) {
  var elkQ = [];
  return function (operation, arguments) {
    elkQ.push([operation, arguments || []]);
//    console.log(elkQ);
  };
})(window);

_elk('page_view');

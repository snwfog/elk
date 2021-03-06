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
  var domain = 'http://' + window.location.hostname + '/collect';

  var Strings = {};
  Strings.orEmpty = function (entity) {
    return entity || "";
  };

  var Hooks = function () {};

  Hooks.prototype = {
    _hooks: [],

    register: function (name, f) {
      if (typeof(this._hooks[ name ]) == 'undefined') {
        this._hooks[ name ] = [];
      }
      this._hooks[ name ].push(f);
    },

    call: function (name, data) {
      if (typeof(this._hooks[ name ]) != 'undefined') {
        for (i = 0; i < this._hooks[ name ].length; i++) {
          this._hooks[ name ][ i ](data);
        }
      }
    }
  };

  var Elk = function () {};

  Elk.prototype = {
    hooks: new Hooks(),
    eTagTracking: 0,

    pageview: function (ref) {
      var trackId = this.readTrackId();

      if (!trackId) {
        trackId = this.generateTrackId();
        this.setTrackId(trackId);
      }

      var data = this.grabVanillaVisitorsData(ref, trackId);

      this.hooks.call('preTrack', data);
      this.trackPageView(data);
    },

    // Allow different way of storing cookies
    readTrackId: function () {
      var data = { trackId: "adasdas" };

      this.hooks.call('readTrackId', data);

      return data.trackId ? data.trackId : readCookie('GUID');
    },

    // Allow different way of setting cookies
    setTrackId: function (trackId) {
      setCookie(trackId);
      this.hooks.call('setTrackId', { trackId: trackId });
    },

    // Allow different way of generating the cookie
    generateTrackId: function () {
      var data = { trackId: null }

      this.hooks.call('generateTrackId', data);

      return data.trackId || generateRandomTrackIdFromClient();
    },

    grabVanillaVisitorsData: function (ref, trackId) {
      return {
        'tzo': new Date().getTimezoneOffset(),
        'ref': Strings.orEmpty(ref),
        'ref2': Strings.orEmpty(document.referrer),
        'guid': Strings.orEmpty(trackId),
      };
    },

    trackPageView: function (data) {
      var img = new Image(1, 1);

      var imgSrc = domain + '?guid=' + data[ 'guid' ];

      img.onload = function () {
        hooks.call('postTrack', data);
      };

      img.src = imgSrc;

      console.log('Track Completed', imgSrc)
    }
  };


  function generateRandomTrackIdFromClient() {
    return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  function setCookie(trackId) {
    document.cookie = 'GUID=' + trackId;
    document.cookie += ';path=/; secure; HttpOnly; ';
  }

  function readCookie(cookieName) {
    var cookies = document.cookie.split(';');

    for (var i = 0; i < cookies.length; i++) {
      var cookieValue = getCookieValues(cookies[ i ], cookieName);
      if (cookieValue) {
        return unescape(cookieValue);
      }
    }
  }

  function getCookieValues(cookieString, cookieName) {
    if (cookieString === '') { return null; }
    var posEquals = cookieString.indexOf('=');

    if (posEquals > 0) {
      var extractedName = cookieString.substr(0, posEquals);
      if (extractedName.trim() === cookieName) {
        return cookieString.substr(posEquals + 1);
      }
    }
  }

  var elkQueue = function () {
    var _elk = new Elk();

    this.push = function () {
      try {
        var args = arguments[ 0 ];
        switch (args[ 0 ]) {
          case 'elkTrackPageView':
            _elk.pageview.apply(_elk, args.slice(1));
            break;
          case 'elkRegister':
            _elk.hooks.register.apply(_elk.hooks, args.slice(1));
            break;
        }
      } catch (e) {}
    };
  };

  var _oldElkQ = window._elkQ;
  window._elkQ = new elkQueue();

  window._elkQ.push.apply(window._elkQ, _oldElkQ);
})(window, document);

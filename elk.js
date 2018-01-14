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

      preHook();
      trackPageView();
      postHook();
    },
  };

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
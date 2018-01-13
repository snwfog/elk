(function(window, document) {
  var Elk = function() {};

  Elk.prototype = {
    pageView = function() {
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

  var staticQueue = window._elk;
  window._elk = new Elk();
})(window, document)


_elk = (function(window) {
  var elkQ = [];
  return function(operation, arguments) {
    elkQ.push([operation, arguments || []]);
//    console.log(elkQ);
  };
})(window);

_elk('page_view');
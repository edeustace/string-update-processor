(function() {

  window.com = window.com || {};

  com.ee = com.ee || {};

  com.ee.string = com.ee.string || {};

  this.com.ee.string.KeyCodeParser = (function() {
    var BACKSPACE, CHROME_CHARS, DELETE;

    BACKSPACE = 8;

    DELETE = 46;

    CHROME_CHARS = {
      186: ":",
      187: "=",
      188: ",",
      219: "{",
      221: "}",
      222: "\"",
      220: "\\",
      191: {
        normal: "/",
        shift: "?"
      },
      190: "."
    };

    function KeyCodeParser() {
      null;
    }

    KeyCodeParser.prototype.getAddition = function(e) {
      var obj, out;
      if (CHROME_CHARS[e.keyCode.toString()] != null) {
        obj = CHROME_CHARS[e.keyCode.toString()];
        if (typeof obj === "string") {
          return obj;
        } else {
          if (obj.hasOwnProperty("shift") && e.shiftKey) {
            return obj.shift;
          } else {
            return obj.normal;
          }
        }
      }
      if (this.isDelete(e)) return "";
      if (this._isEnter(e)) return "\n";
      out = String.fromCharCode(e.keyCode);
      if (!e.shiftKey) out = out.toLowerCase();
      return out;
    };

    KeyCodeParser.prototype.isDelete = function(event) {
      return event.keyCode === BACKSPACE || event.keyCode === DELETE;
    };

    KeyCodeParser.prototype._isEnter = function(e) {
      return e.keyCode === 13;
    };

    return KeyCodeParser;

  })();

}).call(this);

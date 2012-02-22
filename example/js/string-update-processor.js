(function() {

  window.com = window.com || {};

  com.ee = com.ee || {};

  com.ee.string = com.ee.string || {};

  this.com.ee.string.StringUpdateProcessor = (function() {
    var NORMAL, REGEX_CHARS, SPECIAL;

    REGEX_CHARS = "*.|[]$()";

    NORMAL = "a-z,A-Z,0-9,.,=,:,;,_,{,},',\",?,\\/,-,\\\\,\\+";

    SPECIAL = "\\s,\\n,\\t";

    function StringUpdateProcessor() {
      console.log("constructor");
      this.matchAll = this._initMatchAll();
    }

    StringUpdateProcessor.prototype.init = function(initString) {
      var c, s, _i, _len, _ref;
      this.initString = initString;
      this.latest = this.initString;
      s = this.initString;
      s = s.replace(/\\/g, "\\\\");
      s = s.replace(/\+/g, "\\+");
      _ref = REGEX_CHARS.split("");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        s = this._escape(s, c);
      }
      s = s.replace(new RegExp("\\?", "g"), this.matchAll);
      console.log("s: [" + s + "]");
      this.pattern = new RegExp("^" + s + "$");
      console.log("StringUpdateProcessor::init pattern: [" + this.pattern + "]");
      return null;
    };

    StringUpdateProcessor.prototype._initMatchAll = function() {
      var c, chars, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
      chars = "";
      _ref = REGEX_CHARS.split("");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        chars += "\\" + c + "|";
      }
      _ref2 = NORMAL.split(",");
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        c = _ref2[_j];
        chars += "" + c + "|";
      }
      chars += ",|";
      _ref3 = SPECIAL.split(",");
      for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
        c = _ref3[_k];
        chars += "" + c + "|";
      }
      chars = chars.substring(0, chars.length - 1);
      return "[" + chars + "]*";
    };

    /*
      # escape a char so it is not evaluated as a regex operator
      # eg: "*" -> "\*"
    */

    StringUpdateProcessor.prototype._escape = function(s, ch) {
      var regex, replace;
      regex = new RegExp("\\" + ch, "g");
      replace = "\\" + ch;
      return s.replace(regex, replace);
    };

    StringUpdateProcessor.prototype.update = function(proposedString) {
      var s;
      s = proposedString;
      console.log("update:: string: [" + s + "]  pattern: [" + this.pattern + "]");
      if (this.pattern.test(s)) {
        console.debug("legal!");
        this.latest = s;
      }
      return this.latest;
    };

    StringUpdateProcessor.prototype.isLegal = function(proposedString) {
      var legal;
      legal = this.pattern.test(proposedString);
      console.log("StringUpdateProcessor::isLegal: " + legal);
      return legal;
    };

    StringUpdateProcessor.prototype.escapeBackSlashes = function(s) {
      return s.replace(/\\/g, "\\\\");
    };

    return StringUpdateProcessor;

  })();

}).call(this);

(function() {

  window.com = window.com || {};

  com.ee = com.ee || {};

  com.ee.string = com.ee.string || {};

  this.com.ee.string.TextareaHook = (function() {
    var BACKSPACE, DELETE;

    BACKSPACE = 8;

    DELETE = 46;

    function TextareaHook(textarea, processor) {
      var _this = this;
      this.textarea = textarea;
      this.processor = processor;
      this.ignoredCodes = [37, 38, 39, 40];
      $(this.textarea).keydown(function(event) {
        return _this.processInput(_this, event);
      });
      this.parser = new com.ee.string.KeyCodeParser();
    }

    TextareaHook.prototype.processInput = function(field, event) {
      var addition, deletePressed, end, first, firstPart, newString, proposed, second, secondPart, start;
      console.log("TextareaHook:processInput: keyCode: " + event.keyCode);
      if (this.ignoreIt(event.keyCode)) return true;
      addition = this.parser.getAddition(event);
      addition = addition.replace(/\//g, "\/");
      console.log("addition: " + addition);
      deletePressed = false;
      if (event.keyCode === BACKSPACE || event.keyCode === DELETE) {
        console.log("delete pressed!");
        deletePressed = true;
      }
      if (deletePressed) {
        newString = $("#textarea").val();
        start = event.target.selectionStart;
        end = event.target.selectionEnd;
        first = newString.substring(0, start - 1);
        second = newString.substring(end);
        proposed = first + second;
        console.log("proposed: " + proposed);
        return this.processor.isLegal(proposed);
      } else {
        newString = $("#textarea").val();
        firstPart = newString.substring(0, event.target.selectionStart);
        secondPart = newString.substring(event.target.selectionStart);
        newString = firstPart + addition + secondPart;
        console.log("propose: [" + newString + "]");
        return this.processor.isLegal(newString);
      }
    };

    TextareaHook.prototype.ignoreIt = function(keyCode) {
      return this.ignoredCodes.indexOf(keyCode) !== -1;
    };

    return TextareaHook;

  })();

}).call(this);

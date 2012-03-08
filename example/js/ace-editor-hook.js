(function() {

  window.com = window.com || {};

  com.ee = com.ee || {};

  com.ee.string = com.ee.string || {};

  this.com.ee.string.AceEditorHook = (function() {
    var BACKSPACE, DELETE;

    BACKSPACE = 8;

    DELETE = 46;

    function AceEditorHook(aceEditor, processor) {
      this.aceEditor = aceEditor;
      this.processor = processor;
      this.ignoredCodes = [37, 38, 39, 40];
      this._initListeners();
      this._isProcessing;
      this.parser = new com.ee.string.KeyCodeParser();
    }

    AceEditorHook.prototype._initListeners = function() {
      var $textarea,
        _this = this;
      $textarea = $(this.aceEditor.container).find("textarea");
      if ($textarea.length !== 1) throw "must have one textarea";
      $textarea.keydown(function(e) {
        var proposedChange;
        proposedChange = _this.getProposedChange(e);
        return _this.processor.isLegal(proposedChange);
      });
      this.aceEditor.commands.addCommand({
        name: 'intercept backspace',
        bindKey: {
          win: 'Backspace',
          mac: 'Backspace',
          sender: 'editor'
        },
        exec: function(env, args, request) {
          return _this.onBackspacePressed(env, args, request);
        }
      });
      return null;
    };

    AceEditorHook.prototype.onBackspacePressed = function(env, args, request) {
      var mockEvent, proposed;
      mockEvent = {
        keyCode: BACKSPACE
      };
      proposed = this.getProposedChange(mockEvent);
      if (this.processor.isLegal(proposed)) return env.remove("left");
    };

    AceEditorHook.prototype.getProposedChange = function(e) {
      var addition, firstPart, newString, range, secondPart, start;
      this._isProcessing = true;
      newString = this.aceEditor.getSession().getValue();
      range = this.getStringSelection();
      start = range.start;
      addition = this.parser.getAddition(e);
      addition = addition.replace(/\//g, "\/");
      if (this.parser.isDelete(e)) if (start === range.end) start -= 1;
      firstPart = newString.substring(0, start);
      secondPart = newString.substring(range.end);
      newString = firstPart + addition + secondPart;
      this._isProcessing = false;
      return newString;
    };

    /*
      # returns an raw string selection object: 
      # {start: 0, end: 1}
      # converts from the rows/columns model that Ace uses
    */

    AceEditorHook.prototype.getStringSelection = function() {
      var end, out, range, start, stringEnd, stringStart;
      this.aceEditor;
      range = this.aceEditor.getSelection().getRange();
      start = range.start;
      end = range.end;
      stringStart = this._convertRowColumnToStringIndex(start);
      stringEnd = this._convertRowColumnToStringIndex(end);
      out = {
        start: stringStart < stringEnd ? stringStart : stringEnd,
        end: stringStart > stringEnd ? stringStart : stringEnd
      };
      return out;
    };

    /*
      # Performs a conversion
    */

    AceEditorHook.prototype._convertRowColumnToStringIndex = function(range) {
      var column, d, index, line, lines, row, total;
      row = range.row;
      column = range.column;
      d = this.aceEditor.getSession().getDocument();
      lines = d.getAllLines();
      if (row === 0) {
        return column;
      } else {
        total = 0;
        for (index in lines) {
          line = lines[index];
          if (index < row) {
            total += line.length + 1;
          } else {
            break;
          }
        }
        return total + column;
      }
    };

    AceEditorHook.prototype.processInput = function(field, event) {
      var deletePressed, end, first, firstPart, newString, proposed, second, secondPart, start;
      if (this.ignoreIt(event.keyCode)) return true;
      deletePressed = false;
      if (event.keyCode === BACKSPACE || event.keyCode === DELETE) {
        deletePressed = true;
      }
      if (deletePressed) {
        newString = $("#textarea").val();
        start = event.target.selectionStart;
        end = event.target.selectionEnd;
        first = newString.substring(0, start - 1);
        second = newString.substring(end);
        proposed = first + second;
        return this.processor.isLegal(proposed);
      } else {
        newString = $("#textarea").val();
        firstPart = newString.substring(0, event.target.selectionStart);
        secondPart = newString.substring(event.target.selectionStart);
        newString = firstPart + String.fromCharCode(event.keyCode) + secondPart;
        return this.processor.isLegal(newString);
      }
    };

    AceEditorHook.prototype.ignoreIt = function(keyCode) {
      return this.ignoredCodes.indexOf(keyCode) !== -1;
    };

    return AceEditorHook;

  })();

}).call(this);

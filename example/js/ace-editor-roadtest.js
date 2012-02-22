(function() {
  var initEditor;

  window.onload = function() {
    return initEditor();
  };

  initEditor = function() {
    var ScalaMode, editor, hook, initVal, processor;
    console.log("init editor");
    editor = ace.edit("editor");
    editor.setTheme("ace/theme/twilight");
    editor.getSession().setTabSize(4);
    editor.setHighlightActiveLine(false);
    editor.setShowPrintMargin(false);
    editor.renderer.setShowGutter(false);
    ScalaMode = ace.require("ace/mode/scala").Mode;
    editor.getSession().setMode(new ScalaMode());
    window.ace = window.ace || {};
    window.ace.editor = editor;
    initVal = "/**\n* The map function takes two arguments: a function (f) and a sequence (s).\n* Map returns a new sequence consisting of the result of applying f to each item of s.\n* Do not confuse the map function with the map data structure.\n*/\nList(1,2,3).map( (_ + 5)) == ?";
    editor.getSession().setValue(initVal);
    processor = new com.ee.string.StringUpdateProcessor();
    processor.init(initVal);
    return hook = new com.ee.string.AceEditorHook(editor, processor);
  };

}).call(this);

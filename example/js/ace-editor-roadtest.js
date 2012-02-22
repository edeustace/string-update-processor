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
    initVal = "import scala.xml._\n\n/**\n* getNodesWithAttributeValue  node : Node, value : String   : List[Node]\n*/\n?\n\nval xml = <div>\n  <span class=\"test\">hello</span>\n  <div class=\"test\"><p>hello</p></div>\n</div>\n\ngetNodesWithAttributeValue xml, \"test\"  == \n      List[Node] \n        <span class=\"test\">hello</span>, \n        <div class=\"test\"><p>hello</p></div>";
    editor.getSession().setValue(initVal);
    processor = new com.ee.string.StringUpdateProcessor();
    processor.init(initVal);
    return hook = new com.ee.string.AceEditorHook(editor, processor);
  };

}).call(this);

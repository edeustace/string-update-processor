window.onload = ->
  initEditor() 

initEditor = ->
  console.log "init editor" 
  editor = ace.edit "editor" 
  editor.setTheme "ace/theme/twilight" 
  editor.getSession().setTabSize(4)
  editor.setHighlightActiveLine false 
  editor.setShowPrintMargin false 
  editor.renderer.setShowGutter false 
  ScalaMode = ace.require("ace/mode/scala").Mode
  editor.getSession().setMode new ScalaMode()
  window.ace = window.ace || {} 
  window.ace.editor = editor

  initVal = """import scala.xml._

/**
* getNodesWithAttributeValue  node : Node, value : String   : List[Node]
*/
?

val xml = <div>
  <span class="test">hello</span>
  <div class="test"><p>hello</p></div>
</div>

getNodesWithAttributeValue xml, "test"  == 
      List[Node] 
        <span class="test">hello</span>, 
        <div class="test"><p>hello</p></div>
"""


  editor.getSession().setValue initVal
  processor = new com.ee.string.StringUpdateProcessor() 
  processor.init  initVal 
  hook = new com.ee.string.AceEditorHook editor, processor 

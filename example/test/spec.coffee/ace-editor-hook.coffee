describe "string-update-processor", ->

  _assertStartEnd = (hook, startIndex, endIndex) ->
    expect(hook.getStringSelection().start).toBe startIndex
    expect(hook.getStringSelection().end).toBe endIndex
    null 

  _e = ->
    window.ace.editor

  it "can convert from rows,columns to selection with no selection", ->
    expect(true).toBe true

    _e().getSession().setValue("hello");

    now = _e().getSession().getValue()

    expect(now).toBe "hello"

    _e().getSession().getSelection().moveCursorTo(0,0)

    hook = new com.ee.string.AceEditorHook(_e() )

    selection = hook.getStringSelection()
    
    expect(selection.start).toBe 0
    
    threeLines = "line 1\nline 2\nline 3"

    _e().getSession().setValue threeLines
    _e().getSession().getSelection().moveCursorTo(2,0)
    
    _assertStartEnd hook, 14, 14
    
    null

  it "can convert row,column to string selection when something is selected", ->
    
    hook = new com.ee.string.AceEditorHook(_e() )
    threeLines = "line one\nline two\nline three"
    _e().getSession().setValue( threeLines)
    _e().getSession().getSelection().moveCursorTo(2,1)
    #select i
    _e().getSession().getSelection().selectRight()
    
    t = threeLines.substring(19,20)
    console.log ">> [#{t}]"
    _assertStartEnd hook, 19, 20

    _e().getSession().getSelection().selectRight()

    _assertStartEnd hook, 19, 21

    _e().getSession().getSelection().selectAll()
    _assertStartEnd hook, 0, threeLines.length
    null

window.com = (window.com || {})
com.ee = (com.ee || {})
com.ee.string = (com.ee.string || {})

class @com.ee.string.AceEditorHook

  BACKSPACE = 8
  DELETE = 46


  constructor: (@aceEditor, @processor) ->
    @ignoredCodes = [37,38,39,40]
    @_initListeners()
    @_isProcessing
    @parser = new com.ee.string.KeyCodeParser()

  _initListeners: ->
    console.log "_initListeners"
    $textarea = $(@aceEditor.container).find("textarea")
    throw "must have one textarea" if $textarea.length != 1

    $textarea.keydown (e) =>
      console.log "keydown"
      proposedChange = @getProposedChange(e)
      @processor.isLegal proposedChange

    @aceEditor.commands.addCommand
      name: 'intercept backspace'
      bindKey:
        win: 'Backspace'
        mac: 'Backspace'
        sender: 'editor'
      exec: (env,args,request) => @onBackspacePressed(env,args,request)
    null

  onBackspacePressed: (env,args,request)->
    console.log "backspace pressed"
    mockEvent =
      keyCode: BACKSPACE
    proposed = @getProposedChange(mockEvent)
    if @processor.isLegal proposed
      console.log "backspace - is legal - remove"
      env.remove "left"
  

  getProposedChange: (e) ->
    console.log "AceEditorHook::getProposedChange:: keyCode: #{e.keyCode}"
    @_isProcessing = true
    newString = @aceEditor.getSession().getValue()
    range = @getStringSelection()

    start = range.start
    addition = @parser.getAddition e
    addition = addition.replace( /\//g, "\/")
    if @parser.isDelete(e) 
      if start == range.end
        start -= 1

    firstPart = newString.substring 0, start
    secondPart = newString.substring range.end
    console.log "AceEditorHook::getProposedChange: addition: #{addition}"
    #console.log "[#{firstPart}] + [#{addition}] + [#{secondPart}]"
    newString = firstPart + addition + secondPart
    #console.log "proposed String: [#{newString}]"
    @_isProcessing = false
    newString

  ###
  # returns an raw string selection object: 
  # {start: 0, end: 1}
  # converts from the rows/columns model that Ace uses
  ###
  getStringSelection: ->
    @aceEditor
  
    range =  @aceEditor.getSelection().getRange()
    start = range.start
    end = range.end

    stringStart = @_convertRowColumnToStringIndex start 
    stringEnd = @_convertRowColumnToStringIndex end
    
    out = 
      start: if( stringStart < stringEnd ) then stringStart else stringEnd
      end: if( stringStart > stringEnd ) then stringStart else stringEnd
    
    out

  ###
  # Performs a conversion
  ###
  _convertRowColumnToStringIndex: (range ) ->
    
    row = range.row
    column = range.column
    d = @aceEditor.getSession().getDocument()
    lines = d.getAllLines()
    
    
    if row == 0
      column
    else
      total = 0
      for index, line of lines

        if index < row
          total += (line.length + 1) # + 1 for new line
        else
         break
      total + column

  processInput:(field,event) ->
    console.log(event.srcElement.value, event.keyCode)

    if @ignoreIt(event.keyCode)
      return true

    deletePressed = false
    
    if event.keyCode == BACKSPACE || event.keyCode == DELETE 
      console.log "delete pressed!"
      deletePressed = true

    if deletePressed 
      newString = $("#textarea").val()

      start = event.target.selectionStart
      end = event.target.selectionEnd
      first = newString.substring(0, start - 1 )
      second = newString.substring( end )

      proposed = first + second 
      console.log "proposed: " + proposed
      @processor.isLegal proposed
    else
      newString = $("#textarea").val()
      firstPart = newString.substring 0, event.target.selectionStart
      secondPart = newString.substring event.target.selectionStart
      newString = firstPart + String.fromCharCode(event.keyCode) + secondPart
      console.log "new String: " + newString
      @processor.isLegal newString 
  
  ignoreIt: (keyCode) ->
    @ignoredCodes.indexOf(keyCode) != -1

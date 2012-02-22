window.com = (window.com || {})
com.ee = (com.ee || {})
com.ee.string = (com.ee.string || {})

class @com.ee.string.TextareaHook

  BACKSPACE = 8
  DELETE = 46

  constructor: (@textarea, @processor)->
    @ignoredCodes = [37,38,39,40]
    #$(@textarea).keypress( (event) =>  @processInput this, event)
    $(@textarea).keydown( (event) => @processInput this, event )
    @parser = new com.ee.string.KeyCodeParser()
    
  processInput:(field,event) ->
    console.log "TextareaHook:processInput: keyCode: #{event.keyCode}"
    if @ignoreIt(event.keyCode)
      return true

    
    addition = @parser.getAddition event
    addition = addition.replace /\//g, "\/"
    console.log "addition: #{addition}"
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
      newString = firstPart + addition + secondPart
      console.log "propose: [#{newString}]"
      @processor.isLegal newString 
  
  ignoreIt: (keyCode) ->
    @ignoredCodes.indexOf(keyCode) != -1

window.com = (window.com || {})
com.ee = (com.ee || {})
com.ee.string = (com.ee.string || {})

class @com.ee.string.KeyCodeParser

  BACKSPACE = 8
  DELETE = 46

  CHROME_CHARS = 
    186: ":"
    187: "="
    188: ","
    189: "-"
    219: "{"
    221: "}"
    222: "\""
    220: "\\"
    191: 
      normal: "/"
      shift: "?"
    190: "."

  constructor: ->
    null
  
  getAddition: (e) ->
    if CHROME_CHARS[e.keyCode.toString()]?
      obj = CHROME_CHARS[e.keyCode.toString()] 
      if typeof(obj) == "string"
        return obj
      else
        if obj.hasOwnProperty("shift") && e.shiftKey
          return obj.shift
        else
          return obj.normal

    if @isDelete e
      return ""

    if @_isEnter e
      return "\n"

    out = String.fromCharCode e.keyCode
    if !e.shiftKey
      out = out.toLowerCase()

    out

  isDelete: (event) ->
    event.keyCode == BACKSPACE || event.keyCode == DELETE 

  _isEnter: (e) ->
    e.keyCode == 13

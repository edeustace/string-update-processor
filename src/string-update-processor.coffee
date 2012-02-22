window.com = (window.com || {})
com.ee = (com.ee || {})
com.ee.string = (com.ee.string || {})


class @com.ee.string.StringUpdateProcessor

  REGEX_CHARS = "*.|[]$()"
  NORMAL = "a-z,A-Z,0-9,.,=,:,;,_,{,},',\""
  SPECIAL = "\\s,\\n,\\t"
  constructor: ->
    console.log "constructor"
    @matchAll = @_initMatchAll()
  
  init: (@initString) ->
    @latest = @initString
    s = @initString
    
    # remove backslashes first as we add them later
    s = s.replace /\\/g, "\\\\"
    
    for c in REGEX_CHARS.split ""
      s = @_escape s, c

    # add the .* to the sanitized string
    s = s.replace( new RegExp("\\?","g"), @matchAll)
    console.log "s: [#{s}]"
    @pattern = new RegExp "^#{s}$"

  _initMatchAll: ->
    chars = ""

    for c in REGEX_CHARS.split ""
      chars += "\\#{c}|"

    for c in NORMAL.split ","
      chars += "#{c}|"

    chars += ",|"

    for c in SPECIAL.split ","
      chars += "#{c}|"

    chars += "."
    #chars = chars.substring(0, chars.length - 1)

    "[#{chars}]*"
  ###
  # escape a char so it is not evaluated as a regex operator
  # eg: "*" -> "\*"
  ###
  _escape: ( s, char ) ->
    regex = new RegExp("\\#{char}", "g")
    replace = "\\#{char}"
    s.replace regex, replace

  update: (proposedString) ->
    s = proposedString
    console.log "update:: string: [#{s}]  pattern: [#{@pattern}]"

    if @pattern.test s
      console.debug "legal!"
      @latest = s
    @latest 

  isLegal: (proposedString) ->
    legal = @pattern.test proposedString
    console.log "StringUpdateProcessor::isLegal: #{legal}"
    legal

  escapeBackSlashes: (s) ->
    s.replace(/\\/g, "\\\\")
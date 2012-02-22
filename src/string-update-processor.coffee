window.com = (window.com || {})
com.ee = (com.ee || {})
com.ee.string = (com.ee.string || {})


class @com.ee.string.StringUpdateProcessor

  REGEX_CHARS = "*.|[]$()"
  NORMAL = "a-z,A-Z,0-9,.,=,:,;,_,{,},',\",?,\\/,-,\\\\,\\+,>,\\-"
  SPECIAL = "\\s,\\n,\\t"
  constructor: ->
    #console.log "constructor"
    @matchAll = @_initMatchAll()
  
  init: (@initString) ->
    @latest = @initString
    s = @initString
    
    # remove regex characters first as we add them later
    s = s.replace /\\/g, "\\\\"
    s = s.replace /\+/g, "\\+"

    for c in REGEX_CHARS.split ""
      s = @_escape s, c

    # add the .* to the sanitized string
    s = s.replace( new RegExp("\\?","g"), @matchAll)
    #console.log "s: [#{s}]"
    @pattern = new RegExp "^#{s}$"
    #console.log "StringUpdateProcessor::init pattern: [#{@pattern}]"
    null

  _initMatchAll: ->
    chars = ""

    for c in REGEX_CHARS.split ""
      chars += "\\#{c}|"

    for c in NORMAL.split ","
      chars += "#{c}|"

    chars += ",|"

    for c in SPECIAL.split ","
      chars += "#{c}|"

    chars = chars.substring(0, chars.length - 1)

    "[#{chars}]*"


  ###
  # escape a char so it is not evaluated as a regex operator
  # eg: "*" -> "\*"
  ###
  _escape: ( s, ch ) ->
    regex = new RegExp("\\#{ch}", "g")
    replace = "\\#{ch}"
    s.replace regex, replace

  update: (proposedString) ->
    s = proposedString
    #console.log "update:: string: [#{s}]  pattern: [#{@pattern}]"

    if @pattern.test s
      console.debug "legal!"
      @latest = s
    @latest 

  isLegal: (proposedString) ->
    legal = @pattern.test proposedString
    #console.log "StringUpdateProcessor::isLegal: #{legal}"
    ##console.log "StringUpdateProcessor::isLegal: pattern: [#{@pattern}]"
    legal

  escapeBackSlashes: (s) ->
    s.replace(/\\/g, "\\\\")

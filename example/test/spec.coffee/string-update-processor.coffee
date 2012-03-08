describe "string-update-processor", ->


  fiddle = ->
    #regex = new RegExp("^\.\*\\|\[\]\$ .*$", "g");
    regex = /^\.\*\\|\[\]\$ .*$/
    regex = /^\.\*\\\|\[\]\$ .*$/
    logTest = ( string ) ->
        #console.log( "[" + regex + "]  [" + string + "] = " + regex.test(string) );      
        
    logTest(  ".*\\|[]$ hello" )
    logTest(  "bad .*\\|[]$ h" )
    null

  assertUpdate = (processor, shouldEqual, updateString) ->
    #console.log "assertUpdate: #{updateString}"
    if shouldEqual
      expect(processor.update(updateString)).toBe updateString
    else
      expect(processor.update(updateString)).toNotBe updateString
    null
  
  it "can deal with regex chars", ->
    initVal = """+ == ?"""
    processor = new com.ee.string.StringUpdateProcessor()

    processor.init initVal
    assertUpdate processor, true, initVal.replace("?", "hello")
    assertUpdate processor, true, initVal.replace("?", "+/-*%")
    assertUpdate processor, true, initVal.replace("?", "&&")
    assertUpdate processor, true, initVal.replace("?", "_")
    assertUpdate processor, true, initVal.replace("?", "|")
    assertUpdate processor, true, initVal.replace("?", "\\")
    assertUpdate processor, true, initVal.replace("?", "^")
    assertUpdate processor, true, initVal.replace("?", "~")
    assertUpdate processor, true, initVal.replace("?", "{}()")
    assertUpdate processor, true, initVal.replace("?", "$")
    assertUpdate processor, true, initVal.replace("?", "#")
    assertUpdate processor, true, initVal.replace("?", "<>")
    assertUpdate processor, true, initVal.replace("?", "`")
    assertUpdate processor, true, initVal.replace("?", ",.?:;")

  it "a == b", ->
    processor = new com.ee.string.StringUpdateProcessor()
    processor.init("? == b")
    assertUpdate(processor, true, "a == b")
    assertUpdate(processor, false, "bananas")
    null

  it "abcd", ->
    processor = new com.ee.string.StringUpdateProcessor()

    processor.init("a?b?c?d")
    assertUpdate( processor, true, "a b c d")
    assertUpdate( processor, true, "aaabcd b c d")
    assertUpdate( processor, true, "a b c d a b c d")
    assertUpdate( processor, false, "a b c d a b c d ")
    assertUpdate( processor, true, "a__b_c_d" )
    assertUpdate( processor, true, "abcd")
    null

  it "can handle multiline", ->

    processor = new com.ee.string.StringUpdateProcessor()

    multilineString = """import scala._
    /**/
    ?

    true == true"""

    updated = multilineString.replace("?", "hello")
    processor.init multilineString
    assertUpdate processor, true, updated
    assertUpdate processor, false, multilineString + "!!!"
    null

  it "can handle regex chars in the string", ->
    processor = new com.ee.string.StringUpdateProcessor()
    string = ".*\\|[]$ ?"

    processor.init string
    update = string.substring(0, string.length - 1) + "hello"
    assertUpdate processor, true, update
    assertUpdate processor, false, "bad string - " + string 

  it "can handle multiline insertion changes", ->

    initVal = """a?b"""

    processor = new com.ee.string.StringUpdateProcessor()

    processor.init initVal
    assertUpdate processor, true, initVal.replace("?", "hello\nthere")
    assertUpdate processor, false, "\na b"
    assertUpdate processor, false, "a b\n"

  it "can handle commas insertion changes", ->

    initVal = """a?b"""

    processor = new com.ee.string.StringUpdateProcessor()

    processor.init initVal
    assertUpdate processor, true, initVal.replace("?", ",")


  it "can handle forward and back slash insertion changes", ->

    initVal = """a?b"""

    processor = new com.ee.string.StringUpdateProcessor()

    processor.init initVal
    assertUpdate processor, true, initVal.replace("?", "\/")


  it "can handle forward and back slash insertion changes", ->

    initVal = """a?b"""

    processor = new com.ee.string.StringUpdateProcessor()

    processor.init initVal
    assertUpdate processor, true, initVal.replace("?", "\\")
  
 

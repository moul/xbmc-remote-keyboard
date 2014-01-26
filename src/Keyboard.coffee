{Base} = require './Base'

# http://wiki.xbmc.org/index.php?title=Keyboard
class Keyboard extends Base
  start: =>
    @debug 'start'
    @on   'input',        @onInput
    @on   'setInputMode', (mode) => @mode = mode
    @emit 'api',          'input.left'

    [@mode, @textBuffer] = ['action', '']

  apiSendMap:
    'LEFT':             'Left'
    'RIGHT':            'Right'
    'UP':               'Up'
    'DOWN':             'Down'
    'NEWLINE':          'Select'
    'ESC':              'Home'
    127:                'Back'         #backspace
    'm':                'Showosd'
    'o':                'Showcodec'
    'c':                'ContextMenu'
    'i':                'Info'

  apiExecuteActionMap:
    'p':                'play'
    'f':                'fullscreen'

  onInput: (human, c, i) =>
    @debug 'onInput', human, c, i
    @log "human:", human, 'c:', c, 'i:', i
    if i is 9
      @toggleMode()

    fn = @["onInput_#{@mode}"]
    if fn?
      fn human, c, i
    else
      @log "Unknown mode"

  onInput_text: (human, c, i) =>
    @debug 'onInput_text', human, c, i
    if human is c
      if i is 127
        @textBuffer = @textBuffer[0...@textBuffer.length - 1]
      else
        @textBuffer += c
      @log @textBuffer
    else
      if human is 'NEWLINE'
        @emit 'sendText', @textBuffer
        @textBuffer = ''
      else
        @onInput_action human, c, i

  onInput_action: (human, c, i) =>
    @debug 'onInput_action', human, c, i
    for key in [human, c, i]
      if @apiSendMap[key]?
        @log   "sending Input.#{@apiSendMap[key]} (#{key})"
        return @emit 'apiSendInput', @apiSendMap[key]
      if @apiExecuteActionMap[key]?
        @log   "sending Input.ExecuteAction(#{@apiExecuteActionMap[key]}) (#{key})"
        return @emit 'api.Input.ExecuteAction', @apiExecuteActionMap[key]
      if @["on_#{key}"]?
        return do @["on_#{key}"]
    @emit 'unknownInput', human, c, i

  on_q:     =>
    @debug 'on_q'
    @emit 'quit'

  toggleMode: =>
    @debug 'toggleMode'
    @mode = if @mode is 'action' then 'text' else 'action'
    @log "mode is", @mode

module.exports =
  Keyboard: Keyboard
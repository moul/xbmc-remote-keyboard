{Base} = require './Base'

# http://wiki.xbmc.org/index.php?title=Keyboard
class Keyboard extends Base
  start: =>
    @on 'input', @onInput
    @emit 'api', 'input.left'

  apiSendMap:
    'LEFT':             'left'
    'RIGHT':            'right'
    'UP':               'up'
    'DOWN':             'down'
    'NEWLINE':          'select'
    'ESC':              'home'
    127:                'back'         #backspace
    'm':                'showosd'
    'o':                'showcodec'
    'c':                'contextmenu'
    'i':                'info'

  #Input.SendText string, done

  # apiExecuteActionMap:
  #Input.ExecuteAction action

  onInput: (c, i) =>
    for key in [c, i]
      if @apiSendMap[key]?
        @log   "sending Input.#{@apiSendMap[key]} (#{key})"
        return @emit 'apiSendInput', @apiSendMap[key]
      if @["on_#{key}"]?
        return do @["on_#{key}"]
    @emit 'unknownInput', c, i

  on_q:     => @emit 'quit'

module.exports =
  Keyboard: Keyboard
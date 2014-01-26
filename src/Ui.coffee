{Base} = require './Base'
nc     = require 'ncurses'

class Ui extends Base
  start: =>
    @debug 'start'
    @win = new nc.Window()
    do @initLogProxy if @options.verbose or @options.debug
    nc.showCursor = false
    @win.on    'inputChar', @onInputChar
    process.on 'SIGWINCH',  @onSIGWINCH
    process.on 'SIGINT',    @onSIGINT
    do @draw

  initLogProxy: =>
    @debug 'initLogProxy'
    @logBuffer = []
    @oldLog = console.log
    console.log = @log

  log: (args...) =>
    @debug 'log', args...
    @logBuffer.push [args...]
    do @draw

  draw: =>
    @debug 'draw'
    do @win.erase
    @win.insstr 0, 0, 'Press Q to quit'
    if @options.verbose or @options.debug
      limit = Math.min(nc.lines - 3, @logBuffer.length)
      base = Math.max(0, @logBuffer.length - limit)
      for i in [0...limit]
        message = @logBuffer[base + i].join ' '
        #message = "#{nc.lines} #{base} #{@logBuffer.length} #{limit} #{i} #{message}"
        @win.insstr i + 2, 0, message
    do @win.refresh

  close: =>
    @debug 'close'
    do @win.erase
    do nc.cleanup

  human: (c, i) =>
    @debug 'human', c, i
    for key, val of nc.keys
      return key if val is i
    return c

  onInputChar: (c, i) =>
    @debug 'onInputChar', c, i
    @emit 'rawInput', c, i
    @emit 'input',    @human(c, i), c, i

  onSIGWINCH: =>
    @debug 'onSIGWINCH'
    do @draw

  onSIGINT:   =>
    @debug 'onSIGINT'
    @emit 'quit'

module.exports =
  Ui: Ui
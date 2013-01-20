{Base} = require './Base'
nc     = require 'ncurses'

class Ui extends Base
  start: =>
    @win = new nc.Window()
    if @options.verbose
      do @initLogProxy
    nc.showCursor = true
    @win.on    'inputChar', @onInputChar
    process.on 'SIGWINCH',  @onSigWinch
    do @draw

  initLogProxy: =>
    @logBuffer = []
    @oldLog = console.log
    console.log = @log

  log: (args...) =>
    return unless @options.verbose
    @logBuffer.push [args...]
    do @draw

  draw: =>
    do @win.erase
    @win.insstr 0, 0, 'Press Q to quit'
    if @options.verbose
      for i in [0..nc.lines - 2]
        unless @logBuffer[i]?
          break
        @win.insstr i + 2, 0, @logBuffer[i].join ' '
    do @win.refresh

  close: =>
    do @win.erase
    do nc.cleanup

  human: (c, i) =>
    for key, val of nc.keys
      if val is i
        return key
    return c

  onInputChar: (c, i) =>
    @emit 'rawInput', c, i
    @emit 'input',    @human(c, i), i

  onSigWinch: =>
    @log 'onSigWinch'

module.exports =
  Ui: Ui
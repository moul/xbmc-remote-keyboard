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
    @logBuffer.push [args...]
    do @draw

  draw: =>
    do @win.erase
    @win.insstr 0, 0, 'Welcome'
    for i in [0..nc.lines - 2]
      unless @logBuffer[i]?
        break
      @win.insstr i + 2, 0, @logBuffer[i].join ' '
    #@oldLog nc.lines
    do @win.refresh

  close: =>
    do @win.erase
    do nc.cleanup

  onInputChar: (c) =>
    @emit 'input', c

  onSigWinch: =>
    @log 'onSigWinch'

module.exports =
  Ui: Ui
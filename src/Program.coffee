fs         = require 'fs'
program    = require 'commander'
{Ui}       = require './Ui'
{Base}     = require './Base'
{Keyboard} = require './Keyboard'

class Program extends Base
  constructor: (@options = {}) ->
    @options.name ?= 'xbmc-remote-keyboard'
    do @initCommander
    return @

  initCommander: =>
    program.name = @options.name
    program
      .version(do Program.getVersion)
      .usage('[options] hostname/ip[:port]')
      .option('-v, --verbose',       'verbose')
      .option('-d, --debug',         'debug')
      .option('-s, --silent',        'do not send message on connection')
      .option('-a, --agent <agent>', 'user agent')

  parseOptions: =>
    program.parse process.argv
    @options extends program
    [@options.host, @options.port] = @options.args[0].split ':'
    @options.host ?= '127.0.0.1'
    @options.port = parseInt(@options.port) || 9090
    @log @options.args

  initXbmc: (fn = null) =>
    {TCPConnection, XbmcApi} = require 'xbmc'
    @xbmcConnection = new TCPConnection
      host:       @options.host
      port:       @options.port
      verbose:    @options.debug
    @xbmcApi = new XbmcApi
      connection: @xbmcConnection
      verbose:    @options.debug
      agent:      @options.agent || 'Remote Keyboard'
      silent:     @options.silent
    @xbmcApi.on 'connection:open', ->
      fn false if fn
    @xbmcApi.on 'connection:error', ->
      fn true if fn

  initKeyboard: (fn = null) =>
    @keyboard = new Keyboard @options
    do @keyboard.start
    fn false if fn

  initUi: (fn = null) =>
    @ui = new Ui @options
    do @ui.start
    fn false if fn

  setupHandlers: =>
    @ui.on 'input', (c, i) =>
      @keyboard.emit 'input', c, i

    @keyboard.on 'quit', =>
      do @close

    @keyboard.on 'apiSendInput', (method, args = null) =>
      @xbmcApi.input[method] args

    @keyboard.on 'unknownInput', (c, i) =>
      @log "Unknown input", c, i

  close: =>
    @log "closing"
    do @ui.close
    process.exit 0

  run: =>
    do @parseOptions
    @initXbmc (err) =>
      @initUi (err) =>
        @initKeyboard (err) =>
          do @setupHandlers

  @getVersion: -> JSON.parse(fs.readFileSync "#{__dirname}/../package.json", 'utf8').version

  @create: (options = {}) -> new Program options

  @run: -> do (do Program.create).run

module.exports =
  Program:    Program
  run:        Program.run
  create:     Program.create
  getVersion: Program.getVersion

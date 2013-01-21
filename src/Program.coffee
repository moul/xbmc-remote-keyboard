fs         = require 'fs'
program    = require 'commander'
{Ui}       = require './Ui'
{Base}     = require './Base'
{Keyboard} = require './Keyboard'
url        = require 'url'

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
      .option('-v, --verbose',             'verbose')
      .option('-d, --debug',               'debug')
      .option('-u, --username <username>', 'username')
      .option('-P, --password <password>', 'password')
      .option('-s, --host <host>',         'hostname/ip')
      .option('-p, --port <port>',         'port',                              9090)
      .option('-s, --silent',              'do not send message on connection')
      .option('-a, --agent <agent>',       'user agent',                        'Remote Keyboard')

  parseOptions: =>
    program.parse process.argv
    @options extends program
    if @options.args[0]?
      arg = @options.args[0]
      arg = "http://#{arg}" unless arg.indexOf('://') is 0
      target = url.parse arg
      @options['port'] = parseInt(target['port']) if target['port']?
      @options['host'] = target['hostname'] if target['hostname']
      [@options.username, @options.password] = target['auth'].split(':') if target['auth']?
    do program.help unless @options.host?

  initXbmc: (fn = null) =>
    {TCPConnection, XbmcApi} = require 'xbmc'
    @xbmcConnection = new TCPConnection
      host:       @options.host
      port:       @options.port
      verbose:    @options.debug
    @xbmcApi = new XbmcApi
      connection: @xbmcConnection
      verbose:    @options.debug
      username:   @options.username
      password:   @options.password
      agent:      @options.agent || 'Remote Keyboard'
      silent:     @options.silent

    @xbmcApi.on 'connection:open', ->
      fn false if fn

    @xbmcApi.on 'connection:error', (e) ->
      fn true, e  if fn

  initKeyboard: (fn = null) =>
    @keyboard = new Keyboard @options
    do @keyboard.start
    fn false if fn

  initUi: (fn = null) =>
    @ui = new Ui @options
    do @ui.start
    fn false if fn

  setupHandlers: =>
    @ui.on 'input', (human, c, i) =>
      @keyboard.emit 'input', human, c, i

    @ui.on 'quit', =>
      do @close

    @keyboard.on 'quit', =>
      do @close

    @keyboard.on 'apiSendInput', (method, args = null) =>
      @xbmcApi.input[method] args

    @keyboard.on 'api.Input.ExecuteAction', (method, args = null) =>
      @xbmcApi.input.ExecuteAction method, args

    @keyboard.on 'unknownInput', (c, i) =>
      @log "Unknown input", c, i

    @keyboard.on 'sendText', (text) =>
      @xbmcApi.input.SendText text

    @xbmcApi.on 'api:Input.OnInputRequested', =>
      @keyboard.emit 'setInputMode', 'text'

    @xbmcApi.on 'api:Input.OnInputFinished', =>
      @keyboard.emit 'setInputMode', 'action'

  close: (reason = '') =>
    console.log if reason then "Exiting (#{reason})" else "closing"
    do @ui.close if @ui
    process.exit 1

  run: =>
    do @parseOptions
    @initXbmc (err, reason = null) =>
      return @close reason if err
      @initUi (err, reason = null) =>
        return @close reason if err
        @initKeyboard (err, reason = null) =>
          return @close reason if err
          do @setupHandlers

  @getVersion: -> JSON.parse(fs.readFileSync "#{__dirname}/../package.json", 'utf8').version

  @create: (options = {}) -> new Program options

  @run: -> do (do Program.create).run

module.exports =
  Program:    Program
  run:        Program.run
  create:     Program.create
  getVersion: Program.getVersion

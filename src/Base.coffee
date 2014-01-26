{EventEmitter} = require 'events'

class module.exports.Base extends EventEmitter
  constructor: (@options = {}) ->
    @log = @debug = require('debug') "xbmc-remote-keyboard:#{@constructor.name}"
    @debug 'constructor'
    return @

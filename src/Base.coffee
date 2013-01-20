{EventEmitter} = require 'events'

class Base extends EventEmitter
  constructor: (@options = {}) ->
    return @

  log: (args...) =>
    return false unless @options.verbose
    name = @?.constructor?.toString?().match(/function\s*(\w+)/)?[1] || 'Base'
    console.log "#{name}>", args...

module.exports =
  Base: Base

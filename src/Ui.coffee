{Base}  = require './Base'
ncurses = require 'ncurses'

class Ui extends Base
  start: =>
    @log 'start'
    setTimeout (=>
      @input 42
      ), 1000

  input: (input) =>
    @log  'input', input
    @emit 'input', input

module.exports =
  Ui: Ui
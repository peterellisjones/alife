class @Creature

  constructor: ->
    @age = 0
    @energy = 10
    @code = []
    @_color = [0, 0, 255]

  setColor: (@_color) ->

  color: ->
    @_color

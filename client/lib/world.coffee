class @World

  constructor: (@_height = 256, @_width = 256)->
    @_num_creatures = 0
    @_world = [0...@_height].map (i) =>
      [0...@_width].map (j) -> null

  add: (creature, x, y) ->
    @_num_creatures += 1
    throw "Cell #{x},#{y} already occupied" unless @_world[y][x] == null

    @_world[y][x] = creature
    creature.x = x
    creature.y = y

  addRandom: (creature) ->
    for i in [0..10]
      [x, y] = randomCoords(@_width, @_height)
      if @at(x, y) == null
        return @add(creature, x, y)

    throw "Random free cell not found within 10 attempts"

  remove: (creature) ->
    x = creature.x
    y = creature.y
    throw "Creature missing coordinates" unless x? and y?
    throw "Creature not found" unless @_world[y][x] == creature
    @_world[y][x] = null
    @_num_creatures -= 1

  moveCreature: (creature, x, y) ->
    throw "Cannot move over another creature" if @at(x, y) != null
    @remove(creature)
    @add(creature, x, y)

  forEach: (func) ->
    for y in [0...@_height]
      for x in [0...@_width]
        func @_world[y][x], x, y

  at: (x, y) ->
    @_world[y][x]

  isEmpty: ->
    @_num_creatures == 0

  height: ->
    @_height

  width: ->
    @_width

  modCoords: (x, y) ->
    x = (x + @_width) % @_width
    y = (y + @_height) % @_height
    [x, y]

randomCoords = (x, y) ->
  rx = Math.floor(x * Math.random())
  ry = Math.floor(y * Math.random())
  [rx, ry]

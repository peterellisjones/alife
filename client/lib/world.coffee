class @World

  constructor: (@_height = 256, @_width = 256)->
    @_numCreatures = 0
    @_creatureSet = {}
    @_world = [0...@_height].map (i) =>
      [0...@_width].map (j) -> null

  add: (creature, x, y) ->
    @_numCreatures += 1
    throw "Cell #{x},#{y} already occupied" unless @_world[y][x] == null

    @_world[y][x] = creature
    creature.x = x
    creature.y = y

    throw "Creature has no ID" unless creature.id
    throw "Creature already in creatureSet" if @_creatureSet[creature.id]
    @_creatureSet[creature.id] = creature

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

    throw "Creature not found" unless @_creatureSet[creature.id]
    delete @_creatureSet[creature.id]

    @_numCreatures -= 1

  moveCreature: (creature, x, y) ->
    throw "Cannot move over another creature" if @at(x, y) != null
    @remove(creature)
    @add(creature, x, y)

  forEachCell: (func) ->
    for y in [0...@_height]
      for x in [0...@_width]
        func @_world[y][x], x, y

  forEachCreature: (func) ->
    for id, creature of @_creatureSet
      func(creature)

  at: (x, y) ->
    @_world[y][x]

  atFloat: (x, y) ->
    x = Math.floor(@_width * x)
    y = Math.floor(@_height * y)
    @at(x, y)

  getById: (id) ->
    @_creatureSet[id]

  isEmpty: ->
    @_numCreatures == 0

  height: ->
    @_height

  width: ->
    @_width

  numCreatures: ->
    @_numCreatures

  modCoords: (x, y) ->
    x = (x + @_width) % @_width
    y = (y + @_height) % @_height
    [x, y]

randomCoords = (x, y) ->
  rx = Math.floor(x * Math.random())
  ry = Math.floor(y * Math.random())
  [rx, ry]

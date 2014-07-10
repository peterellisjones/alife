class @CreatureList

  constructor: ->
    @_id_counter = 0
    @_length = 0
    @_list = {}

  length: ->
    @_length

  add: (creature) ->
    id = @_id_counter

    creature.id = id
    @_list[id] = creature
    @_length += 1

    @_id_counter += 1

  remove: (creature) ->
    id = creature.id
    throw "No ID" unless id?
    creature = @_list[id]
    throw "Creature not found" unless creature?
    delete @_list[id]
    @_length -= 1

  forEach: (func) ->
    for id, creature of @_list
      func(creature)

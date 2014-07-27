class @CreatureFactory
  build: (species) ->
    creature = new Creature()
    creature.energy = 10
    creature.age = 0
    creature.code = species.code
    creature.color = species.color
    creature.id = @_nextId()

    creature

  _nextId: () ->
    @_idCounter or= 0
    @_idCounter += 1

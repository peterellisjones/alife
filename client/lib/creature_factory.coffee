class @CreatureFactory
  build: (species) ->
    creature = new Creature()
    creature.energy = 10
    creature.age = 0
    creature.code = species.code
    creature.color = species.color

    creature

describe 'CreatureSimlulator', ->
  world = null
  creatureList = null
  simulator = null

  beforeEach ->
    world = new World(10, 10)
    creatureList = new CreatureList()

    creatures = [0...5].map () -> new Creature()

    for creature in creatures
      creatureList.add(creature)
      world.addRandom(creature)

    simulator = new CreatureSimulator(world, creatureList)

  describe 'simulate', ->
    it 'executes the code of each creature', ->

      testInstructionMapping =
        simulate: (stack, system) ->
          this.creature.simulated = true

      simulator = new CreatureSimulator(world, creatureList, testInstructionMapping)

      creatureList.forEach (creature) ->
        creature.code = ['simulate']

      simulator.simulate()
      creatureList.forEach (creature) ->
        expect(creature.simulated).toBe(true)

    it 'increments the age of each creture', ->
      creatureList.forEach (creature) ->
        expect(creature.age).toBe(0)
      simulator.simulate()
      creatureList.forEach (creature) ->
        expect(creature.age).toBe(1)

    describe 'when the creature has no energy', ->
      it 'removes the creature', ->
        simulator.simulate()
        expect(creatureList.length()).toBe(5)

        creatureList.forEach (creature) ->
          creature.energy = 0

        simulator.simulate()
        expect(creatureList.length()).toBe(0)

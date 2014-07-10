describe 'CreatureSimlulator', ->

  describe '#simulate', ->
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

    it 'increments the age of each creature', ->
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

    describe 'instruction mapping', ->
      creature = null
      world = null
      simulator = null

      beforeEach ->
        world = new World(10, 10)
        creatureList = new CreatureList()
        creature = new Creature
        creatureList.add(creature)
        world.add(creature, 5, 5)
        simulator = new CreatureSimulator(world, creatureList)

      describe 'move', ->
        describe 'when the stack is empty', ->
          it 'moves in a random direction', ->
            creature.code = ['move']
            simulator.simulate()
            expect(creature.x != 5 or creature.y != 5).toBe(true)

        describe 'when the stack has a value', ->
          it 'moves in that direction', ->
            creature.code = [0, 'move']
            simulator.simulate()
            expect(creature.x).toBe(4)
            expect(creature.y).toBe(4)

            creature.code = [128, 'move']
            simulator.simulate()
            expect(creature.x).toBe(5)
            expect(creature.y).toBe(5)

        describe 'when a creature is in the way', ->
          it 'exits', ->
            blockingCreature = new Creature()
            world.add(blockingCreature, 4, 4)

            creature.code = [0, 'move']
            simulator.simulate()
            expect(creature.x).toBe(5)
            expect(creature.y).toBe(5)

describe 'CreatureSimlulator', ->

  describe '#simulate', ->
    world = null
    creatureList = null
    simulator = null
    creatureFactory = new CreatureFactory()

    beforeEach ->
      world = new World(10, 10)

      creatures = [0...5].map () -> creatureFactory.build(code: [], color: [255, 0, 0])

      for creature in creatures
        world.addRandom(creature)

      simulator = new CreatureSimulator(world)

    it 'executes the code of each creature', ->
      testInstructionMapping =
        simulate: (stack, system) ->
          this.creature.simulated = true

      simulator = new CreatureSimulator(world, testInstructionMapping)

      world.forEachCreature (creature) ->
        creature.code = ['simulate']

      simulator.simulate()
      world.forEachCreature (creature) ->
        expect(creature.simulated).toBe(true)

    it 'increments the age of each creature', ->
      world.forEachCreature (creature) ->
        expect(creature.age).toBe(0)
      simulator.simulate()
      world.forEachCreature (creature) ->
        expect(creature.age).toBe(1)

    describe 'when the creature has no energy', ->
      it 'removes the creature', ->
        simulator.simulate()
        expect(world.numCreatures()).toBe(5)

        world.forEachCreature (creature) ->
          creature.energy = 0

        simulator.simulate()
        expect(world.numCreatures()).toBe(0)

    it 'clips the energy of the creature', ->
      world.forEachCreature (creature) ->
        creature.energy = 255
        creature.code = ['ponder']

      simulator.simulate()
      expect(world.numCreatures()).toBe(5)
      world.forEachCreature (creature) ->
        expect(creature.energy).toBe(255)

    describe 'instruction mapping', ->
      creature = null
      world = null
      simulator = null

      beforeEach ->
        world = new World(10, 10)
        creature = creatureFactory.build(code: ['ponder'], color: [0,0,0])
        world.add(creature, 5, 5)
        simulator = new CreatureSimulator(world)

      describe '#ponder', ->
        it 'gives the creature 1 energy', ->
          energy = creature.energy
          creature.code = ['ponder']
          simulator.simulate()
          expect(creature.energy).toBe(energy + 1)

        it 'exits', ->
          creature.code = ['ponder', 'ponder']
          simulator.simulate()
          expect(creature.energy).toBe(11)

      describe '#move', ->
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
            simulator.simulate(true)
            expect(creature.x).toBe(5)
            expect(creature.y).toBe(5)

        describe 'when a creature is in the way', ->
          it 'does not exit', ->
            blockingCreature = creatureFactory.build(code: [], color: [0,0,0])
            world.add(blockingCreature, 4, 4)

            creature.code = [0, 'move', 'ponder']
            simulator.simulate()
            expect(creature.x).toBe(5)
            expect(creature.y).toBe(5)
            expect(creature.energy).toBe(11)

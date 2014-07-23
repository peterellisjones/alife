describe "creature_factory", ->
  creatureFactory = null

  beforeEach ->
    creatureFactory = new CreatureFactory()

  describe "#build", ->
    describe 'creature', ->
      creature = null
      code = [5, 'move', 'ponder']

      beforeEach ->
        creature = creatureFactory.build(code: code, color: [255, 0, 0])

      it 'has 10 energy', ->
        expect(creature.energy).toEqual(10)

      it 'has 0 age', ->
        expect(creature.age).toEqual(0)

      it 'has the given code', ->
        expect(creature.code).toBe(code)

      it 'has a color', ->
        expect(creature.color).toEqual([255, 0, 0])

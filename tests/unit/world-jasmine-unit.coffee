describe "World", ->
  world = null
  creature = null
  creatureFactory = new CreatureFactory()

  beforeEach ->
    world = new World(10, 20)
    creature = creatureFactory.build(code: [], color: [0, 0, 0])

  it "has height", ->
    expect(world.height()).toBe(10)

  it "has width", ->
    expect(world.width()).toBe(20)

  it "is empty", ->
    expect(world.isEmpty()).toBe(true)

  describe "#add", ->
    it "puts the creature in the world", ->
      world.add(creature, 4, 5)
      expect(world.at(4, 5)).toBe(creature)

    it "gives the creature coordinates", ->
      world.add(creature, 4, 5)
      expect(creature.x).toBe(4)
      expect(creature.y).toBe(5)

  describe "#remove", ->
    it "removes the creature from the world", ->
      creature = {foo: 'bar', id: 1}
      world.add(creature, 4, 5)
      world.remove(creature)
      expect(world.at(4, 5)).toBe(null)
      expect(world.isEmpty()).toBe(true)

  describe "#forEachCell", ->
    it "iterates over each cell", ->
      world.add(creature, 4, 5)

      creatureCount = 0
      emptyCount = 0
      world.forEachCell (cell) ->
        if cell == creature
          creatureCount += 1
        else if cell == null
          emptyCount += 1

      expect(emptyCount).toBe(20 * 10 - 1)
      expect(creatureCount).toBe(1)

  describe "#forEachCreature", ->
    it "iterates over each creature", ->
      world.add(creature, 4, 5)
      creature2 = creatureFactory.build(code: [], color: [0, 0, 0])
      world.add(creature2, 6, 7)

      creatureCount = 0
      world.forEachCreature (creature) ->
        creatureCount += 1

      expect(creatureCount).toBe(2)

  describe "#moveCreature", ->
    it 'moves the creature', ->
      world.add(creature, 4, 5)
      world.moveCreature(creature, 7, 9)

      expect(creature.x).toBe(7)
      expect(creature.y).toBe(9)

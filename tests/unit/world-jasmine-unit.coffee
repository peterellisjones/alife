describe "World", ->
  world = null

  beforeEach ->
    creatureList = new CreatureList()
    world = new World(10, 20)

  it "has height", ->
    expect(world.height()).toBe(10)

  it "has width", ->
    expect(world.width()).toBe(20)

  it "is empty", ->
    expect(world.isEmpty()).toBe(true)

  describe "#add", ->
    it "puts the creature in the world", ->
      creature = {foo: 'bar'}
      world.add(creature, 4, 5)
      expect(world.at(4, 5)).toBe(creature)

    it "gives the creature coordinates", ->
      creature = {foo: 'bar'}
      world.add(creature, 4, 5)
      expect(creature.x).toBe(4)
      expect(creature.y).toBe(5)

  describe "#remove", ->
    it "removes the creature from the world", ->
      creature = {foo: 'bar'}
      world.add(creature, 4, 5)
      world.remove(creature)
      expect(world.at(4, 5)).toBe(null)
      expect(world.isEmpty()).toBe(true)

  describe "#forEach", ->
    it "iterates over each cell", ->
      creature = {foo: 'bar'}
      world.add(creature, 4, 5)

      creatureCount = 0
      emptyCount = 0
      world.forEach (cell) ->
        if cell == creature
          creatureCount += 1
        else if cell == null
          emptyCount += 1

      expect(emptyCount).toBe(20 * 10 - 1)
      expect(creatureCount).toBe(1)

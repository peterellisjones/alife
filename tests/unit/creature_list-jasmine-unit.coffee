describe "creature_list", ->
  creatureList = null

  beforeEach ->
    creatureList = new CreatureList()

  describe "#length", ->
    it "is correct", ->
      expect(creatureList.length()).toBe(0)
      creatureList.add({})
      expect(creatureList.length()).toBe(1)

  describe "#add", ->
    it "assigns the creature a unique id", ->
      creature = {}
      creatureList.add(creature)
      expect(creature.id).toBe(0)
      creature = {}
      creatureList.add(creature)
      expect(creature.id).toBe(1)

  describe "#remove", ->
    it "removes the creature", ->
      creature = {}
      creatureList.add(creature)
      expect(creatureList.length()).toBe(1)
      creatureList.remove(creature)
      expect(creatureList.length()).toBe(0)

  describe "#forEach", ->
    it "iterates over each creature", ->
      for i in [0...4]
        creatureList.add({ foo: i })

      count = 0
      creatureList.forEach (creature) ->
        expect(creature.foo).toBe(count)
        count += 1
      expect(count).toBe(4)

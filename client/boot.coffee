Meteor.startup ->
  world = new World(64, 64)
  creatureList = new CreatureList()
  window.renderer = new Renderer(world)
  window.simulator = new CreatureSimulator(world, creatureList)

  for i in [0...world.width()/2]
    for j in [0...world.height()/2]
      x = Math.floor(Math.random() * world.width())
      y = Math.floor(Math.random() * world.height())
      if world.at(x, y) == null
        creature = new Creature()
        creature.code = ['ponder']
        world.add(creature, x, y)
        creatureList.add(creature)

  renderer.render()

  tick = () =>
    simulator.simulate()
    renderer.render()

  Meteor.setInterval(tick, 1000)

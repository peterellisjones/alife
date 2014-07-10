Meteor.startup ->
  world = new World(64, 64)
  creatureList = new CreatureList()
  window.renderer = new Renderer(world, creatureList)
  window.simulator = new CreatureSimulator(world, creatureList)

  for i in [0...world.width()/4]
    for j in [0...world.height()/4]
      x = Math.floor(Math.random() * world.width())
      y = Math.floor(Math.random() * world.height())
      if world.at(x, y) == null
        creature = new Creature()
        if Math.random() > 0.5
          creature.code = [Math.floor(Math.random() * 255), 'move']
        else
          creature.code = ['move']
          creature.setColor [255, 0, 0]
        world.add(creature, x, y)
        creatureList.add(creature)

  renderer.render()

  tick = () =>
    simulator.simulate()
    renderer.render()

  fps = 20

  Meteor.setInterval(tick, 1000.0 / fps)
  #tick()

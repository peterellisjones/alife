class @Controller
  constructor: ->
    Session.set('simulationStatus', 'stopped')
    @_reset()

  status: ->
    Session.get('simulationStatus')

  tick: ->
    throw "Cannot tick unless stopped" if @status() != 'stopped'
    @_tick()

  _tick: ->
    @_simulator.simulate()
    @_renderer.render()

  run: ->
    throw "Cannot run unless stopped" if @status() != 'stopped'
    tick = @_tick.bind(@)
    @_mrtIntervalId = Meteor.setInterval(tick, 100)
    Session.set('simulationStatus', 'running')

  stop: ->
    throw "Cannot stop unless running" if @status() != 'running'
    Meteor.clearInterval(@_mrtIntervalId)
    Session.set('simulationStatus', 'stopped')

  _reset: ->
    @_world = new World(64, 64)
    @_creatureList = new CreatureList()
    @_renderer = new Renderer(@_world, @_creatureList)
    @_simulator = new CreatureSimulator(@_world, @_creatureList)

    for i in [0...@_world.width()/4]
      for j in [0...@_world.height()/4]
        x = Math.floor(Math.random() * @_world.width())
        y = Math.floor(Math.random() * @_world.height())
        if @_world.at(x, y) == null
          creature = new Creature()
          if Math.random() > 0.5
            creature.code = [Math.floor(Math.random() * 255), 'move']
          else
            creature.code = ['move']
            creature.setColor [255, 0, 0]
          @_world.add(creature, x, y)
          @_creatureList.add(creature)

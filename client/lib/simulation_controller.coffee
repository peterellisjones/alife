class @SimulationController
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
    creature = Session.get('selected_creature')
    if creature
      updated_creature = @_world.getById(creature.id)
      Session.set('selected_creature', updated_creature)

  render: ->
    @_renderer.render()

  reset: ->
    @_reset()
    @_renderer.render()

  run: ->
    throw "Cannot run unless stopped" if @status() != 'stopped'
    tick = @_tick.bind(@)
    @_mrtIntervalId = Meteor.setInterval(tick, 50)
    Session.set('simulationStatus', 'running')

  stop: ->
    throw "Cannot stop unless running" if @status() != 'running'
    Meteor.clearInterval(@_mrtIntervalId)
    Session.set('simulationStatus', 'stopped')

  world: ->
    @_world

  _reset: ->
    Session.set('selected_creature', null)
    @_world = new World(64, 64)
    @_renderer = new Renderer(@_world)
    @_simulator = new CreatureSimulator(@_world)
    @_creatureFactory = new CreatureFactory()

    for i in [0...@_world.width()/3]
      for j in [0...@_world.height()/3]
        x = Math.floor(Math.random() * @_world.width())
        y = Math.floor(Math.random() * @_world.height())
        if @_world.at(x, y) == null

          r = Math.random()
          code = [Math.floor(256 * Math.random()), 'move', 'move', 'ponder']
          # if r < 0.3
          #   code = [Math.floor(256 * Math.random()), 'move', 'move']
          # else if r < 0.6
          #   code =  [Math.floor(256 * Math.random()), 'move', 'move']
          #   #creature.setColor [255, 0, 0]
          # else
          #   code = ['ponder']
          #   #creature.setColor [0, 128, 0]
          creature = @_creatureFactory.build(code: code, color: [255, 0, 0])

          @_world.add(creature, x, y)

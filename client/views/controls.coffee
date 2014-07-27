Template.controls.running = ->
  simulationController.status() == 'running'

Template.controls.events
  'click .stop-btn': ->
    console.log 'Pressed stop'
    simulationController.stop()

  'click .play-btn': ->
    console.log "Pressed play"
    simulationController.run()

  'click .step-forward-btn': ->
    console.log "Pressed step foward"
    simulationController.tick()

  'click .regenerate-btn': ->
    console.log "Pressed regenerate"
    simulationController.reset()

Meteor.startup ->
  simulationController.render()

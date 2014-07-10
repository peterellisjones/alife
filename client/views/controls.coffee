@controller = new Controller()

Template.controls.running = ->
  controller.status() == 'running'

Template.controls.events

  'click .stop-btn': ->
    console.log 'Pressed stop'
    controller.stop()

  'click .play-btn': ->
    console.log "Pressed play"
    controller.run()

  'click .step-forward-btn': ->
    console.log "Pressed step foward"
    controller.tick()

  'click .regenerate-btn': ->
    console.log "Pressed regenerate"
    controller.reset()

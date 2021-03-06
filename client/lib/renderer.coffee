class @Renderer

  constructor: (@_world, @_creatureList) ->

  render: ->
    canvas = document.getElementById('canvas')
    context = canvas.getContext('2d')

    canvas.width = parseInt(canvas.getAttribute('width'))
    canvas.height = parseInt(canvas.getAttribute('height'))

    image = context.getImageData(0, 0, canvas.width, canvas.height)

    cellPixelsW = Math.floor canvas.width * 1.0 / @_world.width()
    cellPixelsH = Math.floor canvas.height * 1.0 / @_world.height()

    @_world.forEachCreature (creature) =>

      x = creature.x
      y = creature.y

      if creature?
        selected_creature = Session.get('selected_creature')
        if selected_creature and selected_creature.id == creature.id
          [r, g, b] = [0, 0, 0]
        else
          [r, g, b] = creature.color
      else
        [r, g, b] = [255, 255, 255]

      for h in [0...cellPixelsH]
        for w in [0...cellPixelsW]
          i = ( (y * cellPixelsH + h) * canvas.width + (x * cellPixelsW + w) ) * 4
          image.data[i] = r
          image.data[i + 1] = g
          image.data[i + 2] = b
          image.data[i + 3] = 255

    context.putImageData(image, 0, 0);

class @Renderer

  constructor: (@_world, @_creatureList) ->

  render: ->
    canvas = document.getElementById('canvas')
    context = canvas.getContext('2d')

    canvas.width = parseInt(canvas.getAttribute('width'))
    canvas.height = parseInt(canvas.getAttribute('height'))

    newImage = context.createImageData(canvas.width, canvas.height)
    arr = context.getImageData(0, 0, canvas.width, canvas.height)
    pixels = arr.data

    cellPixelsW = Math.floor canvas.width * 1.0 / @_world.width()
    cellPixelsH = Math.floor canvas.height * 1.0 / @_world.height()

    @_creatureList.forEach (creature) ->

      x = creature.x
      y = creature.y

      if creature?
        [r, g, b] = creature.color()
      else
        [r, g, b] = [255, 255, 255]

      for h in [0...cellPixelsH]
        for w in [0...cellPixelsW]
          i = ( (y * cellPixelsH + h) * canvas.width + (x * cellPixelsW + w) ) * 4
          newImage.data[i] = r
          newImage.data[i + 1] = g
          newImage.data[i + 2] = b
          newImage.data[i + 3] = 255

    context.clearRect(0, 0, canvas.width, canvas.height);
    context.putImageData(newImage, 0, 0);

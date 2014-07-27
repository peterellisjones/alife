Template.world.events
  'click canvas': (e) ->
     x = (e.pageX-$('canvas').offset().left) / $('canvas').width()
     y = (e.pageY-$("#canvas").offset().top) / $('canvas').height()
     selectionController.select(x, y)

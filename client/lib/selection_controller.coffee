class @SelectionController
  select: (x, y) ->
    creature = simulationController.world().atFloat(x, y)
    if creature
      Session.set('selected_creature', creature)

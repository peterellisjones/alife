Template.creature.creature = ->
  id = Session.get('selected_creature_id')
  if id
    world.getById(id)

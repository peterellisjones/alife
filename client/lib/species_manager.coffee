class @SpeciesManager
  constructor: ->
    @species = {}

  addSpecies: (name, code) ->
    sp =
      code: code
      color: [255, 0, 0]
      name: name
    @species[name] = sp

  removeSpecies: (name) ->
    delete @species[name]

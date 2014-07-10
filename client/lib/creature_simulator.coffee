class @CreatureSimulator

  constructor: (@_world, @_creatureList, @_instructionMapping = {}) ->

  simulate: ->
    for instruction, defaultFunc of @_defaultInstructionMapping
      unless @_instructionMapping[instruction]?
        @_instructionMapping[instruction] = defaultFunc

    interpreter = new Interpreter(@_instructionMapping)

    binding = {
      world: @_world
    }

    @_creatureList.forEach (creature) =>
      return if @_remove_if_dead(creature)

      binding.creature = creature
      interpreter.run(creature.code, binding)

      return if @_remove_if_dead(creature)

      creature.age += 1

  _remove_if_dead: (creature) ->
    if creature.energy <= 0
      @_world.remove(creature)
      @_creatureList.remove(creature)
      true
    else
      false

  _defaultInstructionMapping:
    ponder: (stack, system) ->
      this.creature.energy -= Math.floor(10 * Math.random())

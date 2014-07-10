class @CreatureSimulator

  constructor: (@_world, @_creatureList, @_instructionMapping = {}) ->

  simulate: (recompile = false)->
    for instruction, defaultFunc of @_defaultInstructionMapping
      unless @_instructionMapping[instruction]?
        @_instructionMapping[instruction] = defaultFunc

    interpreter = new Interpreter(@_instructionMapping)


    @_creatureList.forEach (creature) =>
      return if @_remove_if_dead(creature)

      if !creature.compiled_code? or recompile
        binding =
          world: @_world
          creature: creature
        creature.compiled_code = interpreter.compile(creature.code, binding)

      interpreter.exec(creature.compiled_code, binding)

      @_ensure_creature_property_limits(creature)

      return if @_remove_if_dead(creature)

      creature.age += 1

  _remove_if_dead: (creature) ->
    if creature.energy <= 0
      @_world.remove(creature)
      @_creatureList.remove(creature)
      true
    else
      false

  _ensure_creature_property_limits: (creature) ->
    creature.energy = Math.min(255, creature.energy)

  _defaultInstructionMapping:
    ponder: (stack, system) ->
      this.creature.energy += 1

      return system.exit() # can only ponder once

    move: (stack, system) ->
      direction = stack.pop()
      unless direction?
        direction = Math.floor(Math.random() * 256)

      directionMapping = [[-1,-1],[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1]]

      direction = Math.floor(direction / 32)
      direction = Math.clip(direction, 0, 7)

      [dx, dy] = directionMapping[direction]
      [x, y] = this.world.modCoords(this.creature.x + dx, this.creature.y + dy)

      return system.exit() if this.world.at(x, y) != null

      if this.world.at(x, y) == null
        this.world.moveCreature(this.creature, x, y)
        return system.exit() # can only move once

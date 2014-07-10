class @CreatureSimulator

  constructor: (@_world, @_creatureList, @_instructionMapping = {}) ->

  simulate: ->
    for instruction, defaultFunc of @_defaultInstructionMapping
      unless @_instructionMapping[instruction]?
        @_instructionMapping[instruction] = defaultFunc

    interpreter = new Interpreter(@_instructionMapping)


    @_creatureList.forEach (creature) =>
      return if @_remove_if_dead(creature)

      unless creature.compiled_code?
        binding =
          world: @_world
          creature: creature
        creature.compiled_code = interpreter.compile(creature.code, binding)

      interpreter.exec(creature.compiled_code, binding)

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

      this.world.moveCreature(this.creature, x, y)

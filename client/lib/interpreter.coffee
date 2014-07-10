class System

  constructor: ->
    @_exited = false

  exit: ->
    @_exited = true

  hasExited: ->
    @_exited

class @Interpreter

  constructor: (@_instructionMapping = {}) ->
    for instruction, defaultFunc of @_defaultInstructionMapping
      unless @_instructionMapping[instruction]?
        @_instructionMapping[instruction] = defaultFunc

  run: (code, binding = {}) ->
    instructions = @compile(code, binding)
    @exec(instructions)

  exec: (instructions) ->
    stack = []
    system = new System()

    for instruction in instructions
      instruction(stack, system)
      break if system.hasExited()

    result = stack.pop()
    if result? then result else null

  compile: (code, binding) ->
    code.map (instruction) =>
      @_parse(instruction).bind(binding)


  _parse: (instruction) ->
    ###
      If the instruction is a number literal, push onto the stack
      otherwise, look for an instruction mapping
    ###
    if 'string' == typeof instruction and @_instructionMapping[instruction]?
      @_instructionMapping[instruction]
    else if 'number' == typeof instruction
      number = Math.clip(instruction, 0, 255)
      (stack, system) =>
        stack.push(number)
    else
      throw "Unrecognized instruction: #{instruction}"

  _defaultInstructionMapping:
    exit: (stack, system) ->
      system.exit()

    '+': (stack, system) ->
      x = stack.pop()
      y = stack.pop()
      return system.exit() unless x? and y?

      stack.push Math.clip(x + y, 0, 255)

    invert: (stack, system) ->
      x = stack.pop()
      return system.exit() unless x?

      stack.push (x + 128) % 256

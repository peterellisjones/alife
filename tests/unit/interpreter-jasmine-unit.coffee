describe "Interpreter", ->
  interpreter = new Interpreter()

  describe '#run', ->
    describe 'number literals', ->
      it "always clamps between 0 and 256", ->
        code = [-1]
        result = interpreter.run(code)
        expect(result).toBe(0)

        code = [255]
        result = interpreter.run(code)
        expect(result).toBe(255)

    describe 'exit', ->
      it 'exits', ->
        code = [1, 2, 'exit', 3]
        expect(interpreter.run(code)).toBe(2)

    describe 'invert', ->
      it 'returns (x + 128) % 256', ->
        code = [200, 'invert']
        expect(interpreter.run(code)).toBe(72)

      it 'exits if there is nothing on the stack', ->
        code = ['invert', 1, 2, 3]
        expect(interpreter.run(code)).toBe(null)

    describe '+', ->
      it 'adds two numbers on the stack', ->
        code = [5, 7, '+']
        expect(interpreter.run(code)).toBe(12)

      it 'clamps the result', ->
        code = [250, 10, '+']
        expect(interpreter.run(code)).toBe(255)

      it 'exits if there are insufficient arguments', ->
        expect(interpreter.run([1, '+', 100])).toBe(null)
        expect(interpreter.run(['+', 100])).toBe(null)

    describe 'binding', ->
      it 'can be executed with an arbitrary binding', ->
        binding = { executed: false }

        instructionMapping =
          execute: (stack, system) ->
            this.executed = true

        customInterpreter = new Interpreter(instructionMapping)
        customInterpreter.run(['execute'], binding)

        expect(binding.executed).toBe(true)

    describe 'with arbitrary instruction mappings', ->
      it 'runs arbitrary instructions', ->
        creatureDied = false
        instructionMapping =
          killCreature: (stack, system) =>
            creatureDied = true

        customInterpreter = new Interpreter(instructionMapping)
        customInterpreter.run(['killCreature'])

        expect(creatureDied).toBe(true)

      it 'still runs normal instructions', ->
        creatureDied = false
        instructionMapping =
          killCreature: (stack, system) =>
            creatureDied = true

        customInterpreter = new Interpreter(instructionMapping)
        result = customInterpreter.run([1, 'killCreature', 2, 3])

        expect(result).toBe(3)

    it 'returns the last value on the stack', ->
      code = [1, 2, 3]
      expect(interpreter.run(code)).toBe(3)
      expect(interpreter.run([])).toBe(null)

defmodule Aoc.Day17 do
  @moduledoc """
  Day 17 solutions
  https://adventofcode.com/2024/day/17
  """
  alias Aoc.Utils.BitwiseXor

  def execute_part_1(data \\ fetch_data()) do
    {program, register} = parse_input(data)

    program
    |> run(0, register)
    |> Enum.join(",")
  end

  def execute_part_2(data \\ fetch_data()) do
    {program, _register} = parse_input(data)

    # for both test and actual inputs, all registries values depend solely on initial `a` registry in each iteration
    # where 1 iteration is starting from instruction_pointer 0 until returning a value (output).
    # Both test and actual programs have the same cycle:
    #   start with a,
    #   "do stuff",
    #   change a
    #   output a value
    #   return to instruction_pointer 0
    #
    # Moreover, `change a` instruction is constant way between iterations in both programs - `0,3`,
    # meaning that new a value will always be `floor(a/8)`. Reversing this logic and working backwards
    # gives us the a range between iterations to be a = 8 * a + 0..7
    # We also know that in the last iteration, a result has to be 0 so program can halt (so a in 0..7)
    #
    # with those assumptions, we can work backwards through program and use it as expected output
    # only having to check 7 possible values each iteration

    # incrementally take n elements (starting with 1) from the back of the program
    # which will be used as expected program output
    1..length(program)
    # start with a = [0] which is required for program to halt in the last iteration
    # each iteration can return multiple possible a values for the reduced output
    # since a is a range, not a single value
    |> Enum.reduce([0], fn n, a_values ->
      # prepare output
      expected_output = Enum.take(program, -n)

      # create possible a values range to test against input
      0..7
      |> Enum.flat_map(fn i ->
        Enum.map(a_values, &(&1 * 8 + i))
      end)
      |> Enum.filter(fn a_to_check ->
        # we don't care about b and c values - those will get overridden based on a
        register = %{a: a_to_check, b: 0, c: 0}
        # run program with a given registry and check if output matches expected output
        output = run(program, 0, register)

        output == expected_output
      end)
    end)
    # after running all iterations, take the lowest value
    |> Enum.min()
  end

  defp run(program, instruction_pointer, register, output \\ []) do
    program
    |> Enum.slice(instruction_pointer..(instruction_pointer + 1))
    |> read_instruction(register)
    |> case do
      {:write, update_map} ->
        run(program, instruction_pointer + 2, Map.merge(register, update_map), output)

      {:jump, jump} ->
        run(program, jump, register, output)

      {:output, value} ->
        run(program, instruction_pointer + 2, register, output ++ [value])

      :skip ->
        run(program, instruction_pointer + 2, register, output)

      :halt ->
        output
    end
  end

  defp read_instruction([0, operand], register),
    do: division(register, operand) |> result(:write, :a)

  defp read_instruction([1, operand], %{b: register_b}),
    do: BitwiseXor.perform(register_b, operand) |> result(:write, :b)

  defp read_instruction([2, operand], register),
    do: operand |> combo_operand_value(register) |> rem(8) |> result(:write, :b)

  defp read_instruction([3, _operand], %{a: 0}), do: result(nil)
  defp read_instruction([3, operand], %{a: _}), do: result(operand, :jump)

  defp read_instruction([4, _operand], register),
    do: BitwiseXor.perform(register.b, register.c) |> result(:write, :b)

  defp read_instruction([5, operand], register),
    do: operand |> combo_operand_value(register) |> rem(8) |> result(:output)

  defp read_instruction([6, operand], register),
    do: division(register, operand) |> result(:write, :b)

  defp read_instruction([7, operand], register),
    do: division(register, operand) |> result(:write, :c)

  defp read_instruction([], _register), do: result(:halt)

  defp combo_operand_value(number, _register) when number in 0..3, do: number
  defp combo_operand_value(4, register), do: register.a
  defp combo_operand_value(5, register), do: register.b
  defp combo_operand_value(6, register), do: register.c

  defp result(value, :write, key), do: {:write, Map.put(%{}, key, value)}
  defp result(value, :jump), do: {:jump, value}
  defp result(value, :output), do: {:output, value}
  defp result(nil), do: :skip
  defp result(:halt), do: :halt

  # division by operand combo 2 power instruction
  defp division(register, operand),
    do: register.a |> div(2 ** combo_operand_value(operand, register)) |> floor()

  # helpers
  defp parse_input(input) do
    [a, b, c | program] =
      ~r/\d+/
      |> Regex.scan(input)
      |> Enum.map(&(&1 |> hd() |> String.to_integer()))

    register = %{a: a, b: b, c: c}
    {program, register}
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(17)
end

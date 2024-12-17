defmodule Aoc.Day17 do
  @moduledoc """
  Day 17 solutions
  https://adventofcode.com/2024/day/17
  """
  def execute_part_1(data \\ fetch_data()) do
    {program, register} = parse_input(data)

    program
    |> run(0, register)
    |> Enum.join(",")
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
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
    do: bitwise_xor(register_b, operand) |> result(:write, :b)

  defp read_instruction([2, operand], register),
    do: operand |> combo_operand_value(register) |> rem(8) |> result(:write, :b)

  defp read_instruction([3, _operand], %{a: 0}), do: result(nil)
  defp read_instruction([3, operand], %{a: _}), do: result(operand, :jump)

  defp read_instruction([4, _operand], register),
    do: bitwise_xor(register.b, register.c) |> result(:write, :b)

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

  # bitwise xor instruction
  defp bitwise_xor(a, b) do
    binary_a = to_binary(a)
    binary_b = to_binary(b)

    -4..-1
    |> Enum.map(fn bit_index ->
      a_bit = Enum.at(binary_a, bit_index, 0)
      b_bit = Enum.at(binary_b, bit_index, 0)

      xor(a_bit, b_bit)
    end)
    |> to_int()
  end

  defp xor(1, 0), do: 1
  defp xor(0, 1), do: 1
  defp xor(_, _), do: 0

  # binary conversion
  defp to_binary(number),
    do:
      Integer.to_string(number, 2)
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1))

  defp to_int(binary), do: binary |> Enum.join("") |> String.to_integer(2)

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

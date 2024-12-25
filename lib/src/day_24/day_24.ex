defmodule Aoc.Day24 do
  @moduledoc """
  Day 24 solutions
  https://adventofcode.com/2024/day/24
  """
  def execute_part_1(data \\ fetch_data()) do
    {initial_values, logic_gates} = parse_input(data)

    logic_gates
    |> process_gates(initial_values)
    |> Integer.undigits(2)
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

    defp process_gates([], values), do: get_binary_by_key(values, "z")

  defp process_gates(gates, values) do
    # get all gates for which both input values are known
    {gates_to_process, remaining_gates} = Enum.split_with(gates, &input_non_null?(&1, values))

    gates_to_process
    |> Enum.map(&process(&1, values))
    |> Map.new()
    |> Map.merge(values)
    |> then(&process_gates(remaining_gates, &1))
  end

  defp input_non_null?({input_values, _logical_expression, _result_key}, values),
    do: Enum.all?(input_values, &Map.has_key?(values, &1))

  defp process({input_values, logical_expression, result_key}, values) do
    input_values
    |> Enum.map(&Map.get(values, &1))
    |> produce_result(logical_expression)
    |> then(&{result_key, &1})
  end

  defp produce_result([1, 1], "AND"), do: 1
  defp produce_result([1, _], "OR"), do: 1
  defp produce_result([_, 1], "OR"), do: 1
  defp produce_result([1, 0], "XOR"), do: 1
  defp produce_result([0, 1], "XOR"), do: 1
  defp produce_result(_, _), do: 0

  defp get_binary_by_key(values, result_key) do
    values
    # get all key keys
    |> Enum.filter(fn {key, _} -> String.starts_with?(key, result_key) end)
    # sort descending (from most to least significant bit)
    |> Enum.sort_by(fn {key, _} -> key end, :desc)
    |> Enum.map(fn {_, value} -> value end)
  end

  # helpers
  defp parse_input(input) do
    [initial_values, logic_gates] = String.split(input, "\n\n", trim: true)

    initial_values =
      initial_values
      |> String.split("\n", trim: true)
      |> Enum.map(fn value_line ->
        [key, value] = String.split(value_line, ": ")

        {key, String.to_integer(value)}
      end)
      |> Map.new()

    logic_gates =
      logic_gates
      |> String.split("\n", trim: true)
      |> Enum.map(fn gate_line ->
        [value_1, logical_expression, value_2, result_key] =
          String.split(gate_line, [" ", " -> "])

        {[value_1, value_2], logical_expression, result_key}
      end)

    {initial_values, logic_gates}
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(24)
end

defmodule Aoc.Day05 do
  @moduledoc """
  Day 05 solutions
  https://adventofcode.com/2024/day/05
  """
  def execute_part_1(data \\ fetch_data()) do
    {rules, instructions} = parse_input(data)

    instructions
    |> Enum.filter(&is_valid?(&1, rules))
    |> Enum.map(&get_middle_element/1)
    |> Enum.sum()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp is_valid?(instruction, rules) do
    index_by_elem =
      instruction
      |> Enum.with_index()
      |> Map.new()

    rules
    |> Enum.all?(fn [a, b] ->
      a_index = index_by_elem[a]
      b_index = index_by_elem[b]

      is_nil(a_index) or is_nil(b_index) or a_index < b_index
    end)
  end

  defp get_middle_element(instruction),
    do:
      instruction
      |> Enum.count()
      |> div(2)
      |> floor()
      |> then(&Enum.at(instruction, &1))

  # helpers
  defp parse_input(input) do
    [ordering_rules, instructions] = String.split(input, "\n\n", trim: true)

    {
      parse_lines(ordering_rules, "|"),
      parse_lines(instructions, ",")
    }
  end

  defp parse_lines(lines, breakpoint) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(breakpoint, trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(05)
end

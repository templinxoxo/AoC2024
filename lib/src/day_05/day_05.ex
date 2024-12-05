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
    {rules, instructions} = parse_input(data)

    instructions
    |> Enum.reject(&is_valid?(&1, rules))
    |> Enum.map(&fix_instruction(&1, rules))
    |> Enum.map(&get_middle_element/1)
    |> Enum.sum()
  end

  defp is_valid?(instruction, rules) do
    index_by_instruction_elem =
      instruction
      |> Enum.with_index()
      |> Map.new()

    rules
    |> filter_active_instructions(instruction)
    |> Enum.all?(&is_rule_fulfilled(&1, index_by_instruction_elem))
  end

  defp filter_active_instructions(rules, instruction) do
    Enum.filter(rules, fn [a, b] -> a in instruction and b in instruction end)
  end

  defp is_rule_fulfilled([a, b], index_by_instruction_elem) do
    a_index = index_by_instruction_elem[a]
    b_index = index_by_instruction_elem[b]

    is_nil(a_index) or is_nil(b_index) or a_index < b_index
  end

  defp fix_instruction(instruction, rules) do
    active_rules = filter_active_instructions(rules, instruction)

    instruction
    |> Enum.with_index()
    |> Map.new()
    |> flip_incorrect_elements(active_rules)
  end

  defp flip_incorrect_elements(index_by_instruction_elem, active_rules) do
    active_rules
    |> Enum.find(&(!is_rule_fulfilled(&1, index_by_instruction_elem)))
    |> case do
      nil ->
        index_by_instruction_elem
        |> Enum.sort_by(&elem(&1, 1))
        |> Enum.map(&elem(&1, 0))

      rule ->
        index_by_instruction_elem
        |> flip_indices(rule)
        |> flip_incorrect_elements(active_rules)
    end
  end

  defp flip_indices(index_by_instruction_elem, [a, b]) do
    a_index = index_by_instruction_elem[a]
    b_index = index_by_instruction_elem[b]

    Map.merge(
      index_by_instruction_elem,
      %{a => b_index, b => a_index}
    )
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

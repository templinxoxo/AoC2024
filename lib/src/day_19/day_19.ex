defmodule Aoc.Day19 do
  @moduledoc """
  Day 19 solutions
  https://adventofcode.com/2024/day/19
  """
  use Memoize

  def execute_part_1(data \\ fetch_data()) do
    {towels, patterns} = parse_input(data)

    patterns
    |> Enum.map(&combinations_number(&1, towels))
    |> Enum.filter(&(&1 > 0))
    |> Enum.count()
  end

  def execute_part_2(data \\ fetch_data()) do
    {towels, patterns} = parse_input(data)

    patterns
    |> Enum.map(&combinations_number(&1, towels))
    |> Enum.sum()
  end

  defp combinations_number("", _towels), do: 1

  defmemop combinations_number(pattern, towels), expires_in: 60 * 1000 do
    towels
    |> Enum.filter(&String.starts_with?(pattern, &1))
    |> Enum.map(fn towel ->
      pattern
      |> String.slice(String.length(towel), String.length(pattern))
      |> combinations_number(towels)
    end)
    |> Enum.sum()
  end

  # helpers
  defp parse_input(input) do
    [towels, patterns] = String.split(input, "\n\n", trim: true)

    towels = String.split(towels, [",", " "], trim: true)
    patterns = String.split(patterns, "\n", trim: true)

    {towels, patterns}
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(19)
end

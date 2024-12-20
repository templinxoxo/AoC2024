defmodule Aoc.Day19 do
  @moduledoc """
  Day 19 solutions
  https://adventofcode.com/2024/day/19
  """
  use Memoize

  def execute_part_1(data \\ fetch_data()) do
      {towels, patterns} = parse_input(data)

      patterns
      |> Enum.filter(&pattern_possible?(&1, towels))
      |> Enum.count()
    end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp pattern_possible?("", _towels), do: true

  defmemop pattern_possible?(pattern, towels), expires_in: 60 * 1000 do
    towels
    |> Enum.filter(&String.starts_with?(pattern, &1))
    |> Enum.any?(fn towel ->
      pattern
      |> String.slice(String.length(towel), String.length(pattern))
      |> pattern_possible?(towels)
    end)
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

defmodule Aoc.Day01 do
  @moduledoc """
  Day 01 solutions
  https://adventofcode.com/2024/day/01
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> sort_columns()
    |> sum_pair_distances()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()
    |> count_occurrences()
  end

  defp sort_columns(rows) do
    rows
    |> Enum.zip_reduce([], &[&1 | &2])
    |> Enum.map(&Enum.sort(&1, :asc))
    |> Enum.zip_reduce([], &[&1 | &2])
  end

  defp sum_pair_distances(list) do
    list
    |> Enum.map(fn [x, y] -> abs(x - y) end)
    |> Enum.sum()
  end

  defp count_occurrences(list) do
    [ids, duplicates] = Enum.zip_reduce(list, [], &[&1 | &2])

    repetitions_count =
      duplicates
      |> Enum.group_by(& &1)
      |> Enum.map(fn {id, repetitions} -> {id, length(repetitions)} end)
      |> Map.new()

    ids
    |> Enum.map(&(Map.get(repetitions_count, &1, 0) * &1))
    |> Enum.sum()
  end

  # helpers
  defp fetch_data() do
    day = "01"
    Aoc.Utils.Api.get_input(day)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(~r/\s/, trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end

defmodule Aoc.Day02 do
  @moduledoc """
  Day 02 solutions
  https://adventofcode.com/2024/day/02
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> Enum.filter(&is_safe?/1)
    |> Enum.count()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp is_safe?(row) do
    row
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] ->
      case b - a do
        step when step > 0 and step <= 3 -> :inc
        step when step < 0 and step >= -3 -> :dec
        step -> :err
      end
    end)
    |> IO.inspect()
    |> then(fn row ->
      Enum.all?(row, &(&1 == :inc)) or
        Enum.all?(row, &(&1 == :dec))
    end)
  end

  # helpers
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(~r/\s/, trim: true)
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(02)
end

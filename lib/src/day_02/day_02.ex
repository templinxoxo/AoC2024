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
    |> Enum.filter(&is_safe?(&1, allow_error: true))
    |> Enum.count()
  end

  defp is_safe?(row, opts \\ []) do
    row
    |> row_permutations(opts)
    |> Enum.any?(&(&1 |> elements_tilt() |> is_tilt_constant?()))
  end

  defp row_permutations(row, allow_error: true) do
    0..length(row)
    |> Enum.map(fn index ->
      row
      |> Enum.with_index()
      |> Enum.reject(fn {_cell, cell_index} -> cell_index == index end)
      |> Enum.map(fn {cell, _cell_index} -> cell end)
    end)
  end

  defp row_permutations(row, _), do: [row]

  defp elements_tilt(row) do
    row
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] ->
      case b - a do
        step when step > 0 and step <= 3 -> :asc
        step when step < 0 and step >= -3 -> :desc
        _ -> :err
      end
    end)
  end

  defp is_tilt_constant?(row_shift) do
    row_shift
    |> Enum.uniq()
    |> case do
      [:asc] -> true
      [:desc] -> true
      _ -> false
    end
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

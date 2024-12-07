defmodule Aoc.Day06 do
  @moduledoc """
  Day 06 solutions
  https://adventofcode.com/2024/day/06
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> then(fn map ->
      obstacles = get_element_positions(map, "#")

      map
      |> get_element_positions("^")
      |> patrol(:up, obstacles)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp get_element_positions(map, element) do
    map
    |> Enum.flat_map(fn row -> Enum.filter(row, fn {cell, _} -> cell == element end) end)
    |> Enum.map(fn {_, coordinates} -> coordinates end)
  end

  defp patrol([current_position | _] = history, direction, obstacles) do
    next_position = next_step(current_position, direction)

    cond do
      out_of_bounds?(next_position, obstacles) -> history
      next_position in obstacles -> patrol(history, change_direction(direction), obstacles)
      true -> patrol([next_position | history], direction, obstacles)
    end
  end

  defp next_step({x, y}, :up), do: {x, y - 1}
  defp next_step({x, y}, :right), do: {x + 1, y}
  defp next_step({x, y}, :down), do: {x, y + 1}
  defp next_step({x, y}, :left), do: {x - 1, y}

  defp change_direction(:up), do: :right
  defp change_direction(:right), do: :down
  defp change_direction(:down), do: :left
  defp change_direction(:left), do: :up

  defp out_of_bounds?({x, y}, obstacles),
    do: x < 0 or y < 0 or x > get_max(obstacles, 0) or y > get_max(obstacles, 1)

  defp get_max(obstacles, index), do: obstacles |> Enum.map(&elem(&1, index)) |> Enum.max()

  # helpers
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {cell, x} -> {cell, {x, y}} end)
    end)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(06)
end

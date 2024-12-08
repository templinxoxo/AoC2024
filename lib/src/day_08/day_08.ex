defmodule Aoc.Day08 do
  @moduledoc """
  Day 08 solutions
  https://adventofcode.com/2024/day/08
  """
  def execute_part_1(data \\ fetch_data()) do
    map =
      data
      |> parse_input()

    map
    |> group_by_cell()
    |> Enum.map(fn {_cell, coordinates} ->
      coordinates
      |> into_uniq_pairs()
      |> Enum.map(&get_anti_nodes_coordinates/1)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> reject_out_of_bounds(map)
    |> Enum.count()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp get_anti_nodes_coordinates({{x1, y1}, {x2, y2}}) do
    dx = x2 - x1
    dy = y2 - y1

    [{x1 - dx, y1 - dy}, {x2 + dx, y2 + dy}]
  end

  defp into_uniq_pairs(list) do
    0..(length(list) - 2)
    |> Enum.flat_map(fn i ->
      (i + 1)..(length(list) - 1)
      |> Enum.map(fn j ->
        {Enum.at(list, i), Enum.at(list, j)}
      end)
    end)
  end

  defp reject_out_of_bounds(coordinates, map) do
    max_y = length(map) - 1
    max_x = length(Enum.at(map, 0)) - 1

    Enum.reject(coordinates, fn {x, y} ->
      x < 0 or y < 0 or x > max_x or y > max_y
    end)
  end

  # helpers
  defp group_by_cell(map) do
    map
    |> List.flatten()
    |> Enum.group_by(fn {cell, _coordinates} -> cell end)
    |> Enum.map(fn {cell, elements} ->
      {cell, Enum.map(elements, fn {_, {x, y}} -> {x, y} end)}
    end)
    |> Map.new()
    |> Map.drop(["."])
  end

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

  defp fetch_data(), do: Aoc.Utils.Api.get_input(08)
end

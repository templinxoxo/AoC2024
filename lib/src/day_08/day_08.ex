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
    # group coordinates by node type
    |> Enum.map(fn {_cell, coordinates} ->
      coordinates
      # match into uniq pairs
      |> into_uniq_pairs()
      # for each pair get the anti-nodes coordinates
      |> Enum.map(&get_anti_nodes_coordinates/1)
    end)
    # flatten and deduplicate the list of anti-nodes coordinates
    |> flatten_and_deduplicate()
    # reject out of bounds coordinates
    |> reject_out_of_bounds(map_bounds(map))
    |> Enum.count()
  end

  def execute_part_2(data \\ fetch_data()) do
    map =
      data
      |> parse_input()

    bounds = map_bounds(map)

    map
    |> group_by_cell()
    # group coordinates by node type
    |> Enum.map(fn {_cell, coordinates} ->
      coordinates
      # match into uniq pairs
      |> into_uniq_pairs()
      # for each pair get the linear function definition (a and b params)
      |> Enum.map(fn pair ->
        pair
        |> get_linear_function_definition()
        # then for each function, get points in map boundaries
        |> get_function_points_in_bounds(bounds)
      end)
    end)
    # flatten and deduplicate the list coordinates
    |> flatten_and_deduplicate()
    |> Enum.count()
  end

  defp get_anti_nodes_coordinates({{x1, y1}, {x2, y2}}) do
    dx = x2 - x1
    dy = y2 - y1

    [{x1 - dx, y1 - dy}, {x2 + dx, y2 + dy}]
  end

  defp get_linear_function_definition({{x1, y1}, {x2, y2}}) do
    # y = ax + b
    # y = (dy/dx)(x-x1) + y1
    # d = (dy/dx)
    # y = dx - dx1 + y1
    dx = x2 - x1
    dy = y2 - y1

    fn x ->
      x * dy / dx - x1 * dy / dx + y1
    end
  end

  defp get_function_points_in_bounds(linear_function, {max_x, max_y}) do
    0..max_x
    |> Enum.map(fn x ->
      y = linear_function.(x)

      if y >= 0 and y <= max_y and not is_fraction?(y) do
        {round(x), round(y)}
      else
        nil
      end
    end)
    |> Enum.reject(&is_nil/1)
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

  defp reject_out_of_bounds(coordinates, {max_x, max_y}) do
    Enum.reject(coordinates, fn {x, y} ->
      x < 0 or y < 0 or x > max_x or y > max_y
    end)
  end

  # helpers
  @fraction_precision 100
  defp is_fraction?(number) when is_integer(number), do: false

  defp is_fraction?(number) do
    round(number * @fraction_precision) |> rem(@fraction_precision) |> then(&(&1 != 0))
  end

  defp flatten_and_deduplicate(list) do
    list
    |> List.flatten()
    |> Enum.uniq()
  end

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

  defp map_bounds(map) do
    max_y = length(map) - 1
    max_x = length(Enum.at(map, 0)) - 1

    {max_x, max_y}
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(08)
end

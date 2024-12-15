defmodule Aoc.Day15 do
  @moduledoc """
  Day 15 solutions
  https://adventofcode.com/2024/day/15
  """
  def execute_part_1(data \\ fetch_data()) do
    {map, movements} = parse_input(data)

    starting_position = starting_position(map)
    map = replace_at(map, starting_position, ".")

    starting_position
    |> move(movements, map)
    |> gps_score()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp move(_current_position, [], map), do: map

  defp move(current_position, [move | movements], map) do
    destination = change_position(current_position, move)

    case scan_ahead(current_position, move, map) do
      {"#", _position, _distance} ->
        move(current_position, movements, map)

      {".", _position, 0} ->
        move(destination, movements, map)

      {".", position, _distance} ->
        map
        # move 1 box from beginning to end of stack instead of changing each cell
        |> replace_at(destination, ".")
        |> replace_at(position, "O")
        |> then(&move(destination, movements, &1))
    end
  end

  # returns the element immediately before position or after the last box of the box stack in the direction of the move
  defp scan_ahead(current_position, direction, map, distance \\ 0) do
    destination = change_position(current_position, direction)

    case get_at(map, destination) do
      "O" -> scan_ahead(destination, direction, map, distance + 1)
      element -> {element, destination, distance}
    end
  end

  defp change_position({x, y}, "<"), do: {x - 1, y}
  defp change_position({x, y}, ">"), do: {x + 1, y}
  defp change_position({x, y}, "^"), do: {x, y - 1}
  defp change_position({x, y}, "v"), do: {x, y + 1}

  defp starting_position(map) do
    map
    |> list_coordinates()
    |> Enum.find(&is_elem?(&1, "@"))
    |> then(fn {_, {x, y}} -> {x, y} end)
  end

  # helpers
  defp get_at(map, {x, y}) do
    map
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def replace_at(map, {x, y}, element) do
    List.update_at(map, y, fn row ->
      List.replace_at(row, x, element)
    end)
  end

  defp parse_input(input) do
    [map, movements] = String.split(input, "\n\n", trim: true)

    movements = movements |> String.replace("\n", "") |> String.split("", trim: true)

    map =
      map
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    {map, movements}
  end

  defp gps_score(map) do
    map
    |> list_coordinates()
    |> Enum.filter(&is_elem?(&1, "O"))
    |> Enum.map(fn {_, {x, y}} -> x + 100 * y end)
    |> Enum.sum()
  end

  defp list_coordinates(map) do
    map
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {cell, x} ->
        {cell, {x, y}}
      end)
    end)
  end

  defp is_elem?({cell, _}, elem), do: cell == elem

  defp fetch_data(), do: Aoc.Utils.Api.get_input(15)
end

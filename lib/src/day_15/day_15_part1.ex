defmodule Aoc.Day15.Part1 do
  @moduledoc """
  Day 15 solutions
  https://adventofcode.com/2024/day/15
  """
  alias Aoc.Day15.Utils

  def execute(data \\ fetch_data()) do
    {map, movements} = Utils.parse_input(data)

    starting_position = Utils.starting_position(map)
    map = Utils.replace_at(map, starting_position, ".")

    starting_position
    |> move(movements, map)
    |> Utils.gps_score()
  end

  defp move(_current_position, [], map), do: map

  defp move(current_position, [move | movements], map) do
    destination = Utils.change_position(current_position, move)

    case scan_ahead(current_position, move, map) do
      {"#", _position, _distance} ->
        move(current_position, movements, map)

      {".", _position, 0} ->
        move(destination, movements, map)

      {".", position, _distance} ->
        map
        # move 1 box from beginning to end of stack instead of changing each cell
        |> Utils.replace_at(destination, ".")
        |> Utils.replace_at(position, "O")
        |> then(&move(destination, movements, &1))
    end
  end

  # returns the element immediately before position or after the last box of the box stack in the direction of the move
  defp scan_ahead(current_position, direction, map, distance \\ 0) do
    destination = Utils.change_position(current_position, direction)

    case Utils.get_at(map, destination) do
      "O" -> scan_ahead(destination, direction, map, distance + 1)
      element -> {element, destination, distance}
    end
  end

  # helpers
  defp fetch_data(), do: Aoc.Utils.Api.get_input(15)
end

defmodule Aoc.Day16 do
  @moduledoc """
  Day 16 solutions
  https://adventofcode.com/2024/day/16
  """
  def execute_part_1(data \\ fetch_data()) do
    map = parse_input(data)

    map
    # start at the starting position
    |> starting_position()
    |> then(fn {x, y} -> [{{x, y, ">"}, 0}] end)
    |> dijkstra_path_finding(map, [])
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp dijkstra_path_finding(
         [{{x, y, _}, distance} | remaining_steps] = all_steps,
         map,
         visited_nodes
       ) do
    case map |> Enum.at(y, []) |> Enum.at(x) do
      # finish if reached the end
      "E" -> distance
      # skip if reached a wall
      "#" -> dijkstra_path_finding(remaining_steps, map, visited_nodes)
      # add new possible steps otherwise
      _ -> go_from_step(all_steps, map, visited_nodes)
    end
  end

  # each step is a tuple containing coordinates and distance information
  # coordinates are uniq identifier for each cell. Since turning is costly, the direction is part of
  # the coordinates, which will prevent algorithm local minima
  # coordinate = {x, y, direction}
  defp go_from_step([{current_coordinates, _} = step | steps], map, visited_nodes) do
    step
    # get possible next steps
    |> get_next_steps()
    # remove already visited_nodes
    |> Enum.reject(fn {coordinates, _distance} -> coordinates in visited_nodes end)
    # concat with other possible reachable points
    |> Enum.concat(steps)
    # sort by distance and remove more distant duplicates
    |> Enum.sort_by(fn {_coordinates, distance} -> distance end)
    |> Enum.uniq_by(fn {coordinates, _distance} -> coordinates end)
    # call recursively
    |> dijkstra_path_finding(map, [current_coordinates | visited_nodes])
  end

  defp get_next_steps({{x, y, direction} = coordinates, distance}),
    do: [
      {step_forward(coordinates), distance + 1},
      {{x, y, turn_left(direction)}, distance + 1000},
      {{x, y, turn_right(direction)}, distance + 1000}
    ]

  # helpers
  defp step_forward({x, y, ">"}), do: {x + 1, y, ">"}
  defp step_forward({x, y, "<"}), do: {x - 1, y, "<"}
  defp step_forward({x, y, "^"}), do: {x, y - 1, "^"}
  defp step_forward({x, y, "v"}), do: {x, y + 1, "v"}

  defp turn_left(">"), do: "^"
  defp turn_left("^"), do: "<"
  defp turn_left("<"), do: "v"
  defp turn_left("v"), do: ">"

  defp turn_right("<"), do: "^"
  defp turn_right("^"), do: ">"
  defp turn_right(">"), do: "v"
  defp turn_right("v"), do: "<"

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def starting_position(map) do
    map
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {cell, x} -> {cell, {x, y}} end)
    end)
    |> Enum.find(fn {cell, _} -> cell == "S" end)
    |> then(fn {_, {x, y}} -> {x, y} end)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(16)
end

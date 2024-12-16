defmodule Aoc.Day16 do
  @moduledoc """
  Day 16 solutions
  https://adventofcode.com/2024/day/16
  """
  def execute_part_1(data \\ fetch_data()) do
    map = parse_input(data)

    map
    |> starting_position()
    |> into_starting_step()
    |> dijkstra_path_finding(map, [])
    |> elem(0)
  end

  def execute_part_2(data \\ fetch_data()) do
    map = parse_input(data)

    map
    |> starting_position()
    |> into_starting_step()
    |> dijkstra_path_finding(map, [])
    |> elem(1)
    |> travel_backwards()
    |> get_uniq_coordinates()
    |> Enum.count()
  end

  defp dijkstra_path_finding(
         [{{x, y, _} = coordinates, parents_coordinates, distance} | remaining_steps] = all_steps,
         map,
         visited_nodes
       ) do
    case map |> Enum.at(y, []) |> Enum.at(x) do
      # finish if reached the end
      "E" -> {distance, [{coordinates, parents_coordinates} | visited_nodes]}
      # skip if reached a wall
      "#" -> dijkstra_path_finding(remaining_steps, map, visited_nodes)
      # add new possible steps otherwise
      _ -> go_from_step(all_steps, map, visited_nodes)
    end
  end

  # each step is a tuple containing coordinates, parents and distance information
  # coordinates are uniq identifier for each cell. Since turning is costly, the direction is part of
  # the coordinates, which will prevent algorithm local minima
  # coordinate = {x, y, direction}
  # parents_coordinates is a list of all possible neighboring coordinates that reaching current coordinate by
  # has the same (minimal) distance
  defp go_from_step(
         [{current_coordinates, parents_coordinates, _distance} = step | steps],
         map,
         visited_nodes
       ) do
    visited_coordinates =
      Enum.map(visited_nodes, fn {coordinates, _parent_coordinates} -> coordinates end)

    step
    # get possible next steps
    |> get_next_steps()
    # remove already visited_nodes
    |> Enum.reject(fn {coordinates, _parents_coordinates, _distance} ->
      coordinates in visited_coordinates
    end)
    # concat with other possible reachable points
    |> concat_and_sort_parents_coordinates(steps)
    # call recursively
    |> dijkstra_path_finding(map, [{current_coordinates, parents_coordinates} | visited_nodes])
  end

  defp get_next_steps(
         {{x, y, direction} = parent_coordinates, _grandparent_coordinates, distance}
       ) do
    [
      {step_forward(parent_coordinates), distance + 1},
      {{x, y, turn_left(direction)}, distance + 1000},
      {{x, y, turn_right(direction)}, distance + 1000}
    ]
    |> Enum.map(fn {coordinates, distance} -> {coordinates, [parent_coordinates], distance} end)
  end

  # for all reachable possible next steps, group them together by coordinate and choose the shortest distance
  # from all parents to the current coordinate. If there are multiple shortest distance parents, return them all
  # after that - sort resulting steps by distance to get the next step for recursion
  defp concat_and_sort_parents_coordinates(new_steps, steps) do
    new_steps
    # concat new steps with other possible next steps
    |> Enum.concat(steps)
    # group all possible steps by coordinate, returning parents and distances
    |> Enum.group_by(
      fn {coordinates, _parents_coordinates, _distance} -> coordinates end,
      fn {_coordinates, parents_coordinates, distance} -> {parents_coordinates, distance} end
    )
    # for each route to current coordinate, find the shortest distance parents (can be multiple)
    # and group those into patent_coordinates tuple element
    |> Enum.map(fn {coordinates, parents} ->
      shortest_distance_to_element =
        parents |> Enum.map(fn {_, distance} -> distance end) |> Enum.min()

      parents_coordinates =
        parents
        |> Enum.filter(fn {_, distance} -> distance == shortest_distance_to_element end)
        |> Enum.flat_map(fn {coordinates, _distance} -> coordinates end)

      # return as a valid step struct
      {coordinates, parents_coordinates, shortest_distance_to_element}
    end)
    # and sort by distance
    |> Enum.sort_by(fn {_coordinates, _parent_coordinates, distance} -> distance end)
  end

  # going backwards from the most recent addition (finish position), work the way up until the start position
  # start position can be easily distinguished by the fact that it has no parents (parents = [nil])
  # in each step, take all possible parents as next steps in the consecutive iteration. Each tile can have
  # more than 1 way to get to with the same cost
  defp travel_backwards([finish_position | _] = visited_nodes) do
    travel_backwards([finish_position], [], visited_nodes)
  end

  defp travel_backwards(current_steps, path, visited_nodes) do
    current_steps
    |> Enum.flat_map(fn {_coordinates, parents_coordinates} -> parents_coordinates end)
    |> Enum.uniq()
    |> case do
      [] ->
        path

      parents_coordinates ->
        visited_nodes
        |> Enum.filter(fn {coordinates, _} -> coordinates in parents_coordinates end)
        |> travel_backwards(current_steps ++ path, visited_nodes)
    end
  end

  # and finally, we just care about uniq coordinates along the path.
  # taking in the full path, which has coordinates and parent coordinates list as well as distance
  # strip all data except x and y coordinates
  defp get_uniq_coordinates(visited_nodes) do
    visited_nodes
    |> Enum.map(fn {{x, y, _direction}, _parents_coordinates} -> {x, y} end)
    |> Enum.uniq()
  end

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

  defp into_starting_step({x, y}) do
    [
      {
        # add east direction to starting coordinates to get more accurate tuple
        {x, y, ">"},
        # add nil parents list
        [nil],
        # add 0 distance
        0
      }
    ]
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(16)
end

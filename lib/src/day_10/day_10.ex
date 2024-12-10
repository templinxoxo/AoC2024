defmodule Aoc.Day10 do
  @moduledoc """
  Day 10 solutions
  https://adventofcode.com/2024/day/10
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> to_map()
    |> find_trailheads()
    |> remove_duplicated_paths()
    |> get_trailheads_score()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()
    |> to_map()

    0
  end

  defp find_trailheads(nodes_coordinates) do
    nodes_coordinates
    |> Map.get(0)
    |> Enum.map(&[&1])
    |> find_trailheads(nodes_coordinates, 1 )
  end

  defp find_trailheads(trailheads, _nodes_coordinates, 10) do
    trailheads
  end

  defp find_trailheads(paths, nodes_coordinates, step_number) do
    next_step_coordinates = Map.get(nodes_coordinates, step_number)

    paths
    |> Enum.flat_map(fn path ->
      path
      |> List.last()
      |> next_step_position()
      |> Enum.filter(& &1 in next_step_coordinates)
      |> Enum.map(&Enum.concat(path, [&1]))
    end)
    # |> remove_duplicated_paths()
    |> find_trailheads(nodes_coordinates, step_number + 1)
  end

  defp next_step_position({x, y}), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

  defp remove_duplicated_paths(paths) do
    paths
    # remove different paths from the same start to the same end
    |> Enum.uniq_by(fn paths ->
      {List.first(paths), List.last(paths)}
    end)
  end

  # helpers
  defp get_trailheads_score(trailheads) do
    trailheads
    |> Enum.group_by(fn trailhead -> List.first(trailhead) end)
    |> Enum.map(fn {_starting_position, trailheads} -> Enum.count(trailheads) end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {value, x} -> {value, {x, y}} end)
    end)
  end

  defp to_map(matrix) do
    matrix
    |> List.flatten()
    |> Enum.group_by(fn {value, _} -> value end)
    |> Enum.map(fn {value, data} -> {value, Enum.map(data, fn {_, coords} -> coords end)} end)
    |> Map.new()
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(10)
end

defmodule Aoc.Day20 do
  @moduledoc """
  Day 20 solutions
  https://adventofcode.com/2024/day/20
  """
  alias Aoc.Day20.Utils
  alias Aoc.Utils.Api

  def execute(allowed_cheat_distance) do
    20
    |> Api.get_input()
    |> execute(allowed_cheat_distance)
    |> filter_cheats_by_saved_distance(100)
    |> count()
  end

  def execute(data, allowed_cheat_distance) do
    map = Utils.parse_input(data)

    map
    |> Utils.bfs()
    # |> Utils.print(map)
    |> cheat_options(allowed_cheat_distance, map)
    |> cheat_save_distance_frequencies()
  end

  defp cheat_options(path, allowed_cheat_distance, map) do
    0..(length(path) - 1)
    # for each step of the path to finish
    |> Enum.flat_map(fn i ->
      [current_coordinates | _] = path_to_finish = Enum.drop(path, i)

      [current_coordinates]
      # get possible cheater moves
      |> get_cheat_moves(map, [], 1, allowed_cheat_distance)
      |> Enum.map(fn {cheat_end_coordinates, cheat_distance} ->
        # and check if the shortcut reaches remaining path to finish
        path_to_finish
        |> Enum.find_index(&(&1 == cheat_end_coordinates))
        |> case do
          nil -> nil
          # if it does, return the {from, to, saved_distance}
          steps -> {current_coordinates, cheat_end_coordinates, steps - cheat_distance}
        end
      end)
      # reject nils or cheats not saving any distance
      |> Enum.reject(fn
        nil -> true
        {_from, _to, distance} -> distance <= 0
      end)
    end)
  end

  defp get_cheat_moves([], _map, _visited, _cheat_step, _allowed_cheat_distance), do: []

  defp get_cheat_moves(_current_positions, _map, _visited, cheat_step, allowed_cheat_distance)
       when cheat_step > allowed_cheat_distance,
       do: []

  defp get_cheat_moves(current_positions, map, visited, cheat_step, allowed_cheat_distance) do
    visited = Enum.concat(visited, current_positions)

    current_positions
    # get possible next steps from current cheat positions
    |> Enum.flat_map(&Utils.get_neighbors/1)
    |> Enum.uniq()
    |> Enum.reject(&(&1 in visited))
    |> Enum.filter(&Utils.in_bounds?(&1, map))
    # split into two groups: back on path and still cheating (still on wall)
    |> then(fn next_positions ->
      # add distance to positions on path -> those are the valid cheats
      valid_cheats =
        next_positions
        |> Enum.filter(&Utils.is_path?(&1, map))
        |> Enum.map(&{&1, cheat_step})

      # for positions still on wall, get next valid cheat moves until cheating distance is still not reached
      # positions_on_wall
      next_positions
      |> get_cheat_moves(
        map,
        visited,
        cheat_step + 1,
        allowed_cheat_distance
      )
      |> Enum.concat(valid_cheats)

      # min by and dedup by coordinates
      # |> Enum.sort_by(fn {coordinates, _distance} -> coordinates end)
      # |> Enum.uniq_by(fn {coordinates, _distance} -> coordinates end)
    end)
  end

  defp cheat_save_distance_frequencies(cheats) do
    cheats
    |> Enum.map(fn {_from, _to, saved_distance} -> saved_distance end)
    |> Enum.frequencies()
  end

  def filter_cheats_by_saved_distance(cheats, min_distance) do
    cheats
    |> Enum.filter(fn {saved_distance, _count} -> saved_distance >= min_distance end)
    |> Map.new()
  end

  defp count(cheats_frequencies),
    do:
      cheats_frequencies
      |> Enum.map(fn {_saved_distance, count} -> count end)
      |> Enum.sum()
end

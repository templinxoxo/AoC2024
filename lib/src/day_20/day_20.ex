defmodule Aoc.Day20 do
  @moduledoc """
  Day 20 solutions
  https://adventofcode.com/2024/day/20
  """
  alias Aoc.Day20.Utils
  alias Aoc.Utils.Api

  def execute_part_1() do
    20
    |> Api.get_input()
    |> execute_part_1()
    |> count_over_100_distance_save()
  end

  def execute_part_1(data) do
    map = Utils.parse_input(data)

    map
    |> Utils.bfs()
    # |> Utils.print(map)
    |> cheat_options(map)
    |> cheat_save_distance_frequencies()
  end

  def execute_part_2(data) do
    data
    |> Utils.parse_input()

    0
  end

  defp cheat_options(path, map) do
    0..(length(path) - 2)
    # for each step of the path to finish
    |> Enum.flat_map(fn i ->
      [current_coordinates | _] = path_to_finish = Enum.drop(path, i)

      current_coordinates
      # get possible cheater moves
      |> get_cheat_moves(map)
      |> Enum.map(fn coordinates ->
        # and check if the shortcut reaches remaining path to finish
        path_to_finish
        |> Enum.find_index(&(&1 == coordinates))
        |> case do
          nil -> nil
          # if it does, return the {from, to, saved_distance}
          steps -> {current_coordinates, coordinates, steps - 2}
        end
      end)
      # reject nils or cheats not saving any distance
      |> Enum.reject(fn
        nil -> true
        {_from, _to, distance} -> distance <= 0
      end)
    end)
  end

  defp get_cheat_moves(coordinates, map) do
    coordinates
    # get cheat_options steps by going to 2nd level neighbors by phasing through walls
    |> Utils.get_neighbors()
    |> Enum.filter(&(not Utils.is_path?(&1, map)))
    |> Enum.flat_map(&Utils.get_neighbors(&1))
    |> Enum.reject(&(&1 == coordinates))
  end

  defp cheat_save_distance_frequencies(cheats) do
    cheats
    |> Enum.map(fn {_from, _to, saved_distance} -> saved_distance end)
    |> Enum.frequencies()
  end

  defp count_over_100_distance_save(cheats) do
    cheats
    |> Enum.filter(fn {_from, _to, saved_distance} -> saved_distance >= 100 end)
    |> Enum.count()
  end
end

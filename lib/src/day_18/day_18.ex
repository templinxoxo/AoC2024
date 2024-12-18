defmodule Aoc.Day18 do
  @moduledoc """
  Day 18 solutions
  https://adventofcode.com/2024/day/18
  """
  @exit_coordinates {70, 70}
  @starting_coordinates {0, 0}

  def execute_part_1() do
    fetch_data()
    |> execute_part_1(@exit_coordinates, 1024)
  end

  def execute_part_1(data, exit_coordinates, number_of_obstacles) do
    data
    |> parse_input()
    |> Enum.take(number_of_obstacles)
    |> then(&dijkstra_path_finding([{@starting_coordinates, 0}], &1, [], exit_coordinates))
    |> elem(1)
  end

  def execute_part_2() do
    fetch_data()
    |> execute_part_2(@exit_coordinates)
  end

  def execute_part_2(data, exit_coordinates) do
    obstacles = parse_input(data)

    get_exit_cutoff_obstacle([], obstacles, length(obstacles), exit_coordinates)
  end

  # traverse graph with obstacles in place
  # if no way out is found,
  # - remove last obstacle
  # - check if new coordinate is near path
  #   - if no -> remove another one
  #   - if yes -> check if starting from this coordinate the end is now reachable
  #     don't reset visited coordinates so the algorithm doesn't re-run the same steps over and over
  defp get_exit_cutoff_obstacle(
         visited_coordinates,
         obstacles,
         number_of_obstacles,
         exit_coordinates
       ) do
    new_opening = Enum.at(obstacles, number_of_obstacles)

    current_steps =
      cond do
        # if no coordinates are visited, start from the beginning and get initial reachable steps
        length(visited_coordinates) == 0 -> [{@starting_coordinates, 0}]
        # if the newly removed obstacle is near the path, start from this coordinate
        # path length can be reset as we don't care about the distance, only about getting to the end
        is_new_opening_near_path?(new_opening, visited_coordinates) -> [{new_opening, 0}]
        # otherwise leave current coordinates empty, which will immediately return no path
        # in dijkstra_path_finding and call get_exit_cutoff_obstacle again with the next obstacle
        true -> []
      end

    obstacles
    |> Enum.take(number_of_obstacles)
    |> then(&dijkstra_path_finding(current_steps, &1, visited_coordinates, exit_coordinates))
    |> case do
      {:ok, _distance} ->
        # if the end is reachable, return the new opening. In the traditional (non reversed) traversal
        # this would be the 1st obstacle to cut off the exit
        new_opening

      {:error, :no_path, visited_coordinates} ->
        # if no path is found, try searching again from the current visited coordinates with 1 obstacle less
        get_exit_cutoff_obstacle(
          visited_coordinates,
          obstacles,
          number_of_obstacles - 1,
          exit_coordinates
        )
    end
  end

  defp dijkstra_path_finding(
         [{coordinates, distance} | _],
         _obstacles,
         _visited_coordinates,
         exit_coordinates
       )
       when coordinates == exit_coordinates,
       do: {:ok, distance}

  defp dijkstra_path_finding(
         [],
         _obstacles,
         visited_coordinates,
         _exit_coordinates
       ),
       do: {:error, :no_path, visited_coordinates}

  defp dijkstra_path_finding(
         [{coordinates, distance} | steps],
         obstacles,
         visited_coordinates,
         exit_coordinates
       ) do
    # print(exit_coordinates, visited_coordinates, obstacles)

    coordinates
    # get possible next steps
    |> get_next_steps()
    # remove already visited coordinates, walls and out of bounds
    |> Enum.reject(fn coordinates ->
      coordinates in obstacles or coordinates in visited_coordinates or
        out_of_bound?(coordinates, exit_coordinates)
    end)
    # add distance to each step
    |> Enum.map(fn coordinates -> {coordinates, distance + 1} end)
    # concat with other possible reachable points
    |> Enum.concat(steps)
    |> Enum.sort_by(fn {_, distance} -> distance end)
    |> Enum.uniq_by(fn {coordinates, _distance} -> coordinates end)
    # call recursively
    |> dijkstra_path_finding(
      obstacles,
      [coordinates | visited_coordinates],
      exit_coordinates
    )
  end

  defp get_next_steps({x, y}),
    do: [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]

  defp out_of_bound?({x, y}, {max_x, max_y}), do: x < 0 or y < 0 or x > max_x or y > max_y

  defp is_new_opening_near_path?(coordinates, visited_coordinates) do
    coordinates
    |> get_next_steps()
    |> Enum.any?(&(&1 in visited_coordinates))
  end

  # helpers
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp print({x, y}, visited, obstacles) do
    IO.puts("")
    IO.puts("")

    0..y
    |> Enum.map(fn y ->
      0..x
      |> Enum.map(fn x ->
        cond do
          {x, y} in visited -> "O"
          {x, y} in obstacles -> "#"
          true -> "."
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(18)
end

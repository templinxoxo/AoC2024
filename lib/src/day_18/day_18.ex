defmodule Aoc.Day18 do
  @moduledoc """
  Day 18 solutions
  https://adventofcode.com/2024/day/18
  """
  @end_coordinates {70, 70}
  @starting_positions [{{0, 0}, 0}]

  def execute_part_1() do
    fetch_data()
    |> execute_part_1(@end_coordinates, 1024)
  end

  def execute_part_1(data, end_coordinates, number_of_obstacles) do
    data
    |> parse_input()
    |> Enum.take(number_of_obstacles)
    |> then(&dijkstra_path_finding(@starting_positions, &1, [], end_coordinates))
  end

  def execute_part_2(data, end_coordinates, number_of_obstacles) do
    0
  end

  defp dijkstra_path_finding(
         [{coordinates, distance} | _],
         _obstacles,
         _visited_coordinates,
         end_coordinates
       )
       when coordinates == end_coordinates,
       do: distance

       defp dijkstra_path_finding(
         [],
         _obstacles,
         _visited_coordinates,
         _end_coordinates
       ),
       do: {:error, :no_path_found}

  defp dijkstra_path_finding(
         [{coordinates, distance} | steps],
         obstacles,
         visited_coordinates,
         end_coordinates
       ) do
        IO.inspect(distance)
    # print(end_coordinates, visited_coordinates, obstacles)

    coordinates
    # get possible next steps
    |> get_next_steps()
    # remove already visited coordinates, walls and out of bounds
    |> Enum.reject(fn coordinates ->
      coordinates in obstacles or coordinates in visited_coordinates or
        out_of_bound?(coordinates, end_coordinates)
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
      end_coordinates
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

defmodule Aoc.Day20.Utils do
  def bfs(map) do
    # get starting point
    map
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.find(fn {cell, _x} -> cell == "S" end)
      |> then(fn
        nil -> nil
        {_, x} -> {x, y}
      end)
    end)
    |> Enum.find(&(not is_nil(&1)))
    # wrap as a list of lists for bfs
    |> then(&[[&1]])
    |> bfs(map)
  end

  def bfs([], _map), do: nil

  def bfs(paths, map) do
    paths
    |> Enum.flat_map(fn [coordinates | _] = path ->
      # get valid next steps
      coordinates
      |> get_neighbors()
      |> Enum.filter(fn step ->
        in_bounds?(step, map) and is_path?(step, map) and step not in path
      end)
      |> Enum.map(&[&1 | path])
    end)
    |> then(fn new_paths ->
      # check if end is reached
      new_paths
      |> Enum.find(fn [coordinates | _] ->
        is_end?(coordinates, map)
      end)
      |> case do
        # if not, continue
        nil -> bfs(new_paths, map)
        path -> Enum.reverse(path)
      end
    end)
  end

  def get_neighbors({x, y}), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
  def in_bounds?({x, y}, map), do: x >= 0 and y >= 0 and not is_nil(get_at(map, {x, y}))
  def is_path?(coordinates, map), do: get_at(map, coordinates) in [".", "E", "S"]
  def is_end?(coordinates, map), do: get_at(map, coordinates) == "E"
  def get_at(map, {x, y}), do: map |> Enum.at(y) |> Enum.at(x)

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def print(path, map) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {cell, x} ->
        if {x, y} in path do
          "O"
        else
          cell
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    path
  end
end

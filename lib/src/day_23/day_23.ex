defmodule Aoc.Day23 do
  @moduledoc """
  Day 23 solutions
  https://adventofcode.com/2024/day/23
  """
  def execute_part_1(data \\ fetch_data()) do
    all_connections = parse_input(data)

    all_nodes = all_connections |> List.flatten() |> Enum.uniq()

    all_nodes
    |> Enum.flat_map(fn connection ->
      IO.inspect(connection)
      # search connections 3 levels deep
      bfs([[connection]], all_connections, 3)
      # get all loops
      |> Enum.filter(fn [start, _, _, finish] -> start == finish end)
    end)
    |> Enum.map(fn loop ->
      loop
      # drop duplicated node
      |> Enum.uniq()
      # sort nodes
      |> Enum.sort()
    end)
    # drop duplicated loops
    |> Enum.uniq()
    |> IO.inspect(charlists: :as_lists)
    |> filter_by_node_leading_letter("t")
    |> Enum.count()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp bfs(paths, _all_connections, 0) do
    paths
  end

  defp bfs(paths, all_connections, depth) do
    paths
    |> Enum.flat_map(fn [current_node | _] = path ->
      used_connections = path
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.flat_map(fn [a, b] -> [[a, b], [b, a]] end)

      all_connections
      # drop used connections
      |> Kernel.--(used_connections)
      # filter all connections from current node
      |> Enum.filter(fn connection -> current_node in connection end)
      |> List.flatten()
      |> Enum.reject(& &1 == current_node)
      # add each of new nodes to map
      |> Enum.map(fn new_node ->
        [new_node | path]
      end)
    end)
    |> bfs(all_connections, depth - 1)
  end

  defp filter_by_node_leading_letter(loops, node_leading_letter) do
    Enum.filter(loops, fn loop ->
      Enum.any?(loop, fn node -> String.starts_with?(node, node_leading_letter) end)
    end)
  end


  defp group(all_connections, group, new_node) do
  end

  # helpers
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.split(row, "-", trim: true)
    end)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(23)
end

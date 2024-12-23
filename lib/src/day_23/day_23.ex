defmodule Aoc.Day23 do
  @moduledoc """
  Day 23 solutions
  https://adventofcode.com/2024/day/23
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> find_connection_sets()
    |> Enum.map(&get_nodes/1)
    |> deduplicate()
    |> Enum.flat_map(&into_sets(&1, 3))
    |> deduplicate()
    |> filter_by_node_leading_letter("t")
    |> Enum.count()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()
    |> find_connection_sets()
    |> Enum.map(&get_nodes/1)
    |> deduplicate()
    |> Enum.max_by(&length/1)
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp find_connection_sets(connection_sets \\ [], all_connections)

  # finish when there is no more connections to go through
  defp find_connection_sets(connection_sets, []) do
    connection_sets
  end

  defp find_connection_sets(connection_sets, [connection | remaining_connections]) do
    [connection]
    # find a new connections set from the next still unused connection
    |> extend_connection_set(remaining_connections)
    # call again with the new connection set and less remaining connections
    |> then(fn new_connection_sets ->
      new_connections = Enum.flat_map(new_connection_sets, & &1)

      connection_sets
      |> Enum.concat(new_connection_sets)
      |> find_connection_sets(remaining_connections)
    end)
  end

  defp extend_connection_set(connections_set, connections) do
    connection_set_nodes = get_nodes(connections_set)

    connections
    # get all new connections that could be reached from all current set nodes
    |> Enum.filter(fn [a, b] ->
      a in connection_set_nodes or b in connection_set_nodes
    end)
    # get all new possible nodes
    |> get_nodes()
    |> Kernel.--(connection_set_nodes)
    # remove nodes that are not connected to all connection_set_nodes
    |> Enum.filter(fn node ->
      Enum.all?(connection_set_nodes, &has_connection?(connections, [&1, node]))
    end)
    # create connections by new nodes
    |> Enum.map(fn node ->
      Enum.flat_map(connection_set_nodes, &[[&1, node], [node, &1]])
    end)
    |> case do
      # if no new connections are found - return finished set
      [] ->
        [connections_set]

      new_connections ->
        new_connections
        |> Enum.flat_map(&extend_connection_set(connections_set ++ &1, connections -- &1))
    end
  end

  def into_sets(set, size) when length(set) == size, do: [set]
  def into_sets(set, 1), do: Enum.map(set, &[&1])
  def into_sets(set, size) when length(set) < size, do: []

  def into_sets(set, size) do
    length(set)..2//-1
    |> Enum.flat_map(fn i ->
      [node | remaining_nodes] = Enum.take(set, -i)

      remaining_nodes
      |> into_sets(size - 1)
      |> Enum.map(&[node | &1])
    end)
  end

  defp has_connection?(connections, connection),
    do: connection in connections or Enum.reverse(connection) in connections

  defp get_nodes(connection_set), do: connection_set |> List.flatten() |> Enum.uniq()

  defp deduplicate(node_sets), do: node_sets |> Enum.map(&Enum.sort/1) |> Enum.uniq()


  defp filter_by_node_leading_letter(nodes, leading_letter),
    do:
      Enum.filter(nodes, fn node -> Enum.any?(node, &String.starts_with?(&1, leading_letter)) end)

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

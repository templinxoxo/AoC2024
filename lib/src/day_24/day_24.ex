defmodule Aoc.Day24 do
  @moduledoc """
  Day 24 solutions
  https://adventofcode.com/2024/day/24
  """
  def execute_part_1(data \\ fetch_data()) do
    {initial_values, logic_gates} = parse_input(data)

    logic_gates
    |> process_gates(initial_values)
    |> Integer.undigits(2)
  end

  @swapped_pairs_number 4
  def execute_part_2(data \\ fetch_data()) do
    {initial_values, logic_gates} = parse_input(data)

    # get expected return value
    expected_value = get_expected_value(initial_values)

    logic_gates
    # get actual bit value from current gates
    |> process_gates(initial_values)
    # get mismatching bits in result and convert to appropriate gates
    |> get_mismatching_bits(expected_value)
    |> Enum.map(&to_key/1)
    # filter only logic gates that point towards faulty gates
    |> get_nodes_pointing_to_result_nodes(logic_gates)
    |> get_gates_to_nodes(logic_gates)
    # split into n-element sets (when n elements were swapped)
    |> into_sets(@swapped_pairs_number)
    # split each set into 2-element sets
    |> Enum.flat_map(&into_sets(&1, 2))
    |> then(fn swaps ->
      IO.inspect("total of #{length(swaps)} swaps to check")
      swaps
    end)
    |> Enum.with_index()
    |> Enum.find(fn {swap, i} ->
      if rem(i, 100) == 0, do: IO.puts("Checking swap #{i}")
      swap_valid?(swap, expected_value, initial_values, logic_gates)
    end)
  end

  defp process_gates([], values), do: get_binary_by_key(values, "z")

  defp process_gates(gates, values) do
    # get all gates for which both input values are known
    {gates_to_process, remaining_gates} = Enum.split_with(gates, &input_non_null?(&1, values))

    gates_to_process
    |> Enum.map(&process(&1, values))
    |> Map.new()
    |> Map.merge(values)
    |> then(&process_gates(remaining_gates, &1))
  end

  defp input_non_null?({input_values, _logical_expression, _result_key}, values),
    do: Enum.all?(input_values, &Map.has_key?(values, &1))

  defp process({input_values, logical_expression, result_key}, values) do
    input_values
    |> Enum.map(&Map.get(values, &1))
    |> produce_result(logical_expression)
    |> then(&{result_key, &1})
  end

  defp produce_result([1, 1], "AND"), do: 1
  defp produce_result([1, _], "OR"), do: 1
  defp produce_result([_, 1], "OR"), do: 1
  defp produce_result([1, 0], "XOR"), do: 1
  defp produce_result([0, 1], "XOR"), do: 1
  defp produce_result(_, _), do: 0

  defp get_expected_value(initial_values) do
    x_wire_value = get_binary_by_key(initial_values, "x") |> Integer.undigits(2)
    y_wire_value = get_binary_by_key(initial_values, "y") |> Integer.undigits(2)

    Integer.digits(x_wire_value + y_wire_value, 2)
  end

  # from all gates -> get all nodes pointing to given nodes
  # and their parents
  # and so on until initial values are reached
  defp get_nodes_pointing_to_result_nodes(result_nodes, all_gates) do
    all_gates
    # filter all gates pointing to current result nodes
    |> Enum.filter(fn {_input_values, _logic_expression, result_key} ->
      result_key in result_nodes
    end)
    # return input nodes from these gates
    |> Enum.flat_map(fn {input_values, _logic_expression, _result_key} ->
      input_values
    end)
    # drop initial value nodes or already processed ones
    |> Enum.reject(fn node ->
      # are those 2 y and x necessary?
      String.starts_with?(node, "x") or
        String.starts_with?(node, "y") or
        node in result_nodes
    end)
    |> Kernel.--(result_nodes)
    |> case do
      [] ->
        result_nodes

      new_nodes ->
        get_nodes_pointing_to_result_nodes(new_nodes ++ result_nodes, all_gates)
    end
  end

  # from set of result nodes -> get all gates that have these nodes as input
  defp get_gates_to_nodes(nodes, all_gates) do
    Enum.filter(all_gates, fn {_input_values, _logic_expression, result_key} ->
      result_key in nodes
    end)
  end

  defp swap_valid?(nodes_to_swap, expected_value, initial_values, all_gates) do
    [nodes_to_swap]
    # swap results between pairs
    |> Enum.flat_map(fn [
      {node_1_values, node_1_logical_expression, node_1_result},
      {node_2_values, node_2_logical_expression, node_2_result}
      ] ->
        [
          {node_1_values, node_1_logical_expression, node_2_result},
          {node_2_values, node_2_logical_expression, node_1_result}
        ]
      end)
    # add to all gates
    |> Kernel.++(all_gates)
    # remove pre-swap gates
    |> Kernel.--(List.flatten(nodes_to_swap))
    # process resulting gates
    |> process_gates(initial_values)
    # compare with expected value
    |> Kernel.==(expected_value)
  end

  defp get_binary_by_key(values, result_key) do
    values
    # get all key keys
    |> Enum.filter(fn {key, _} -> String.starts_with?(key, result_key) end)
    # sort descending (from most to least significant bit)
    |> Enum.sort_by(fn {key, _} -> key end, :desc)
    |> Enum.map(fn {_, value} -> value end)
  end

  defp get_mismatching_bits(bits_1, bits_2) do
    0..(length(bits_1) - 1)
    |> Enum.filter(fn i -> Enum.at(bits_1, i) != Enum.at(bits_2, i) end)
  end

  defp to_key(number) when number < 10, do: "z0#{number}"
  defp to_key(number), do: "z#{number}"

  # helpers
  defp parse_input(input) do
    [initial_values, logic_gates] = String.split(input, "\n\n", trim: true)

    initial_values =
      initial_values
      |> String.split("\n", trim: true)
      |> Enum.map(fn value_line ->
        [key, value] = String.split(value_line, ": ")

        {key, String.to_integer(value)}
      end)
      |> Map.new()

    logic_gates =
      logic_gates
      |> String.split("\n", trim: true)
      |> Enum.map(fn gate_line ->
        [value_1, logical_expression, value_2, result_key] =
          String.split(gate_line, [" ", " -> "])

        {[value_1, value_2], logical_expression, result_key}
      end)

    {initial_values, logic_gates}
  end

  # split list into uniq n-sized sets
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

  defp fetch_data(), do: Aoc.Utils.Api.get_input(24)
end

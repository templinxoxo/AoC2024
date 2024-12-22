defmodule Aoc.Day21 do
  @moduledoc """
  Day 21 solutions
  https://adventofcode.com/2024/day/21
  """
  use Memoize

  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> Enum.map(fn sequence ->
      sequence
      |> find_steering_sequence()
      |> Enum.count()
      |> then(fn length -> length * number(sequence) end)
    end)
    |> Enum.sum()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp find_steering_sequence(sequence) do
    number_pad = number_pad_keys_paths_combinations()
    directional_pad = directional_pad_keys_paths_combinations()

    [sequence]
    |> get_shortest_steering_sequences(number_pad)
    |> get_shortest_steering_sequences(directional_pad)
    |> get_shortest_steering_sequences(directional_pad)
    |> hd()
  end

  defp get_shortest_steering_sequences(sequences, pad) do
    sequences
    |> Enum.flat_map(fn sequence ->
      # each sequence starts at "A"
      ["A"]
      |> Enum.concat(sequence)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn
        [from, from] ->
          [["A"]]

        [from, to] ->
          pad
          # get paths between elements
          |> Map.get({from, to})
          # add "A" press at the end of each move
          |> Enum.map(&(&1 ++ ["A"]))
      end)
      |> flat_concat()
    end)
    |> filter_shortest()
  end

  defp filter_shortest(sequences) do
    max_len = sequences |> Enum.map(&Enum.count/1) |> Enum.min()
    sequences
    |> Enum.filter(&Enum.count(&1) == max_len)
  end

  # +---+---+---+
  # | 7 | 8 | 9 |
  # +---+---+---+
  # | 4 | 5 | 6 |
  # +---+---+---+
  # | 1 | 2 | 3 |
  # +---+---+---+
  #     | 0 | A |
  #     +---+---+
  @number_pad [["7", "8", "9"], ["4", "5", "6"], ["1", "2", "3"], [" ", "0", "A"]]
  defmemop number_pad_keys_paths_combinations(), expires_in: 60_000 do
    Aoc.Day21.PadMoves.all_possible_moves(@number_pad)
  end

  #     +---+---+
  #     | ^ | A |
  # +---+---+---+
  # | < | v | > |
  # +---+---+---+
  @directional_pad [[" ", "^", "A"], ["<", "v", ">"]]
  defmemop directional_pad_keys_paths_combinations(), expires_in: 60_000 do
    Aoc.Day21.PadMoves.all_possible_moves(@directional_pad)
  end

  # flattens list of lists elements and concatenates then into new lists by making every permutation of it's children, ex:
  # [[[1]], [[2, 3], [6, 7]], [[4, 5]]]
  # would become
  # [[1, 2, 3, 4, 5], [1, 6, 7, 4, 5]]
  def flat_concat(results \\ [[]], sequences)

  def flat_concat(results, []), do: results

  def flat_concat(results, [current_steps | sequences]) do
    current_steps
    |> Enum.flat_map(fn steps ->
      results |> Enum.map(fn result -> result |> Enum.concat(steps) end)
    end)
    |> flat_concat(sequences)
  end

  defp number(sequence) do
    sequence
    |> Enum.filter(&String.match?(&1, ~r/\d+/))
    |> Enum.join("")
    |> String.to_integer()
  end

  # helpers
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(21)
end

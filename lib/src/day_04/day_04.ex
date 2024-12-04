defmodule Aoc.Day04 do
  @moduledoc """
  Day 04 solutions
  https://adventofcode.com/2024/day/04
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> word_find("xmas")
    |> length()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()
    |> word_find("mas", direction: :diagonal)
    |> match_into_pairs(1)
    |> length()
  end

  defp word_find(matrix, word, opts \\ []) do
    matrix
    # start from the 1st letter of the word
    # find all coordinates where it appears in the matrix
    |> find_letter_coordinates(String.at(word, 0))
    # then for all the coordinates found
    |> Enum.flat_map(fn coordinates ->
      coordinates
      # find possible coordinates for the rest of the word
      |> find_possible_coordinates(String.length(word), opts)
      # remove out of bound coordinates
      |> reject_out_of_bound(matrix)
      # fetch the words from the coordinates
      |> fetch_words(matrix)
      # remove non-matching words
      |> Enum.filter(fn {match, _} -> compare(match, word) end)
    end)
  end

  defp find_letter_coordinates(matrix, letter) do
    matrix
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        {char, y, x}
      end)
    end)
    |> Enum.filter(fn {char, _y, _x} ->
      compare(char, letter)
    end)
    |> Enum.map(fn {_char, y, x} -> {y, x} end)
  end

  @directions %{
    standard: [{0, 1}, {1, 0}],
    backwards: [{-1, 0}, {0, -1}],
    diagonal: [{-1, -1}, {-1, 1}, {1, -1}, {1, 1}]
  }
  defp find_possible_coordinates({y, x}, length, opts) do
    opts
    |> get_directions()
    |> Enum.map(fn {dy, dx} ->
      0..(length - 1)
      |> Enum.map(fn i -> {y + dy * i, x + dx * i} end)
    end)
  end

  defp get_directions(direction: direction), do: @directions[direction] || []
  defp get_directions(_), do: Map.values(@directions) |> List.flatten()

  defp reject_out_of_bound(coordinates_list, matrix) do
    coordinates_list
    |> Enum.reject(fn coordinates ->
      {x, y} = List.last(coordinates)

      y < 0 or x < 0 or y >= length(matrix) or x >= length(hd(matrix))
    end)
  end

  defp fetch_words(coordinates_list, matrix) do
    coordinates_list
    |> Enum.map(fn coordinates ->
      word =
        coordinates
        |> Enum.map(fn {y, x} -> matrix |> Enum.at(y) |> Enum.at(x) end)
        |> Enum.join()

      {word, coordinates}
    end)
  end

  defp match_into_pairs(matches, by_index) do
    matches
    |> Enum.group_by(fn {_word, coordinates} -> Enum.at(coordinates, by_index) end)
    |> Enum.filter(fn {_index, matches} -> length(matches) == 2 end)
    |> Enum.map(fn {index, _matches} -> index end)
  end

  # helpers
  @spec compare(String.t(), String.t()) :: boolean()
  defp compare(letter1, letter2), do: String.downcase(letter1) == String.downcase(letter2)

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(04)
end

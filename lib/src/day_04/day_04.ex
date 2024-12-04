defmodule Aoc.Day04 do
  @moduledoc """
  Day 04 solutions
  https://adventofcode.com/2024/day/04
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> word_find("xmas")
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp word_find(matrix, word) do
    matrix
    # start from the 1st letter of the word
    # find all coordinates where it appears in the matrix
    |> find_letter_coordinates(String.at(word, 0))
    # then for all the coordinates found
    |> Enum.flat_map(fn coordinates ->
      coordinates
      # find possible coordinates for the rest of the word
      |> find_possible_coordinates(String.length(word))
      # remove out of bound coordinates
      |> reject_out_of_bound(matrix)
      # fetch the words from the coordinates
      |> fetch_words(matrix)
      # remove non-matching words
      |> Enum.filter(&compare(&1, word))
    end)
    |> length()
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

  defp find_possible_coordinates({y, x}, length) do
    [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
    |> Enum.map(fn {dy, dx} ->
      0..(length - 1)
      |> Enum.map(fn i -> {y + dy * i, x + dx * i} end)
    end)
  end

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
      coordinates
      |> Enum.map(fn {y, x} -> matrix |> Enum.at(y) |> Enum.at(x) end)
      |> Enum.join()
    end)
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

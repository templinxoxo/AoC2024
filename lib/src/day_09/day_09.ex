defmodule Aoc.Day09 do
  @moduledoc """
  Day 09 solutions
  https://adventofcode.com/2024/day/09
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> unzip_disc()
    |> move_files()
    |> calculate_checksum()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp unzip_disc(files) do
    files
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.flat_map(fn
      {[file_size, free_space_size], index} ->
        List.duplicate(index, file_size) ++ List.duplicate(nil, free_space_size)

      {[file_size], index} ->
        List.duplicate(index, file_size)
    end)
  end

  defp move_files(files) do
    move_files(files, 0, length(files) - 1)
  end

  defp move_files(files, index, reverse_index) do
    next_free_space_index = get_next_nil_index(files, index, reverse_index)
    next_file_to_move_index = get_prev_non_nil_index(files, reverse_index, index)

    IO.inspect({next_free_space_index, next_file_to_move_index})

    if is_nil(next_free_space_index) or is_nil(next_file_to_move_index) do
      files
    else
      files
      |> List.replace_at(next_free_space_index, Enum.at(files, next_file_to_move_index))
      |> List.replace_at(next_file_to_move_index, nil)
      # |> print()
      |> move_files(next_free_space_index + 1, next_file_to_move_index - 1)
    end
  end

  defp get_next_nil_index(files, index, max_index) do
    Enum.find(index..max_index, fn index ->
      file = Enum.at(files, index)
      is_nil(file)
    end)
  end

  defp get_prev_non_nil_index(files, index, min_index) do
    Enum.find(index..min_index, fn index ->
      file = Enum.at(files, index)
      not is_nil(file)
    end)
  end

  # helpers
  # defp print(files) do
  #   files |> Enum.map(&(&1 || ".")) |> Enum.join("") |> IO.inspect(label: "files")
  #   files
  # end

  defp calculate_checksum(numbers) do
    numbers
    |> Enum.with_index()
    |> Enum.reject(fn {value, _index} -> is_nil(value) end)
    |> Enum.map(fn {value, index} -> value * index end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input |> String.replace("\n", "") |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(09)
end

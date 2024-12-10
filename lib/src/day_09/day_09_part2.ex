defmodule Aoc.Day09.Part2 do
  @moduledoc """
  Day 09 solutions
  https://adventofcode.com/2024/day/09
  """

  def execute(data \\ fetch_data()) do
    data
    |> Aoc.Day09.Part1.parse_input()
    |> unzip_disc()
    |> move_files()
    |> unzip()
    |> Aoc.Day09.Part1.calculate_checksum()
  end

  defp unzip_disc(files) do
    files
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.flat_map(fn
      {[file_size, free_space_size], index} ->
        [{index, file_size}, {nil, free_space_size}]

      {[file_size], index} ->
        [{index, file_size}]
    end)
  end

  defp move_files(files), do: move_files(files, length(files) - 1)

  defp move_files(files, 0), do: files

  defp move_files(files, index) do
    case Enum.at(files, index) do
      {nil, _size} ->
        move_files(files, index - 1)

      {file, size} ->
        files
        |> Enum.take(index)
        |> get_next_nil_index(size)
        |> case do
          nil ->
            move_files(files, index - 1)

          nil_index ->
            {nil, nil_size} = Enum.at(files, nil_index)

            files
            |> List.replace_at(nil_index, [{file, size}, {nil, nil_size - size}])
            |> List.replace_at(index, {nil, size})
            |> List.flatten()
            |> move_files(index - 1)
        end
    end
  end

  defp get_next_nil_index(files, size) do
    Enum.find_index(files, fn {file, file_size} -> file == nil and file_size >= size end)
  end

  defp unzip(files) do
    Enum.flat_map(files, fn {file, size} ->
      List.duplicate(file, size)
    end)
  end

  # helpers
  defp fetch_data(), do: Aoc.Utils.Api.get_input(09)
end

defmodule Aoc.Day25 do
  @moduledoc """
  Day 25 solutions
  https://adventofcode.com/2024/day/25
  """
  def execute_part_1(data \\ fetch_data()) do
    {locks, keys} = parse_input(data)

    locks
    |> Enum.flat_map(fn lock ->
      lock
      |> calculate_pin_heights(".")
      |> IO.inspect()
      |> filter_fitting_keys(keys)
    end)
    |> Enum.count()
  end

  defp filter_fitting_keys(lock, keys) do
    keys
    |> Enum.map(&calculate_pin_heights(&1, "#"))
    |> IO.inspect()
    |> Enum.filter(fn key ->
      lock
      |> Enum.zip(key)
      |> Enum.all?(&pin_match?/1)
    end)
  end

  defp pin_match?({lock_pin, key_pin}) do
    key_pin >= lock_pin
  end

  defp calculate_pin_heights(lock, elem) do
    max_pin_height = lock |> Enum.count() |> Kernel.-(1)
    pins_number = lock |> Enum.at(0) |> Enum.count() |> Kernel.-(1)

    0..pins_number
    |> Enum.map(fn pin_index ->
      # pin column as a row
      0..max_pin_height
      |> Enum.map(fn i ->
        lock
        |> Enum.at(i)
        |> Enum.at(pin_index)
      end)
      |> Enum.find_index(&(&1 == elem))
    end)
  end


  # helpers
  defp parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn chunk ->
      chunk
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
    end)
      # spit into {locks, keys} groups
    |> Enum.split_with(fn group ->
      group |> Enum.at(0) |> Enum.at(0) |> Kernel.==("#")
    end)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(25)
end

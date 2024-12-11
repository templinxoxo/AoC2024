defmodule Aoc.Day11 do
  @moduledoc """
  Day 11 solutions
  https://adventofcode.com/2024/day/11
  """
  use Memoize
  require Integer

  def execute(data \\ fetch_data(), cycles) do
    data
    |> parse_input()
    |> frequencies_list_from_list()
    |> brute_force_cycles(cycles)
    |> frequencies_list_length()
  end

  defp brute_force_cycles(data, 0), do: print(data, 0)

  defp brute_force_cycles(data, cycles) do
    data
    |> print(cycles)
    |> Enum.map(fn {value, repetitions} ->
      value
      |> get_new_values()
      |> Enum.map(&{&1, repetitions})
    end)
    |> List.flatten()
    |> frequencies_list_deduplicate()
    |> brute_force_cycles(cycles - 1)
  end

  defp get_new_values(0), do: [1]

  defmemop get_new_values(value), expires_in: 10 * 60 * 1_000 do
    digits = Integer.digits(value)
    len = length(digits)

    if Integer.is_even(len) do
      digits
      |> Enum.split(round(len / 2))
      |> Tuple.to_list()
      |> Enum.map(&Integer.undigits(&1))
    else
      [value * 2024]
    end
  end

  # helpers
  defp frequencies_list_from_list(values) do
    values
    |> Enum.frequencies()
    |> Map.to_list()
  end

  defp frequencies_list_deduplicate(frequencies_list) do
    frequencies_list
    |> Enum.group_by(fn {value, _} -> value end)
    |> Enum.map(fn {value, frequencies_list} ->
      {value, frequencies_list_length(frequencies_list)}
    end)
  end

  defp frequencies_list_length(frequencies_list) do
    frequencies_list
    |> Enum.map(fn {_, frequencies} -> frequencies end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split(["\n", " "], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp print(frequencies_list, cycles) do
    IO.puts("#{cycles} left. #{frequencies_list_length(frequencies_list)} items in this cycle")
    frequencies_list
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(11)
end

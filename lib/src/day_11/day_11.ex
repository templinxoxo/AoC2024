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
    |> brute_force_cycles(cycles)
    |> Enum.count()
  end

  defp brute_force_cycles(data, 0), do: print(data, 0)
  defp brute_force_cycles(data, cycles) do

    data
    |> print(cycles)
    |> Enum.flat_map(&get_new_values(&1))
    |> brute_force_cycles(cycles - 1)
  end

  defp get_new_values(0), do: [1]

  defmemop get_new_values(value), expires_in: 10 * 60 * 1_000 do
    digits = Integer.digits(value)
    len = length(digits)

    if (Integer.is_even(len)) do
      digits
      |> Enum.split(round(len / 2))
      |> Tuple.to_list()
      |> Enum.map(&Integer.undigits(&1))
    else
      [value * 2024]
    end
  end

  # helpers
  defp parse_input(input) do
    input
    |> String.split(["\n", " "], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp print(data, cycles) do
    IO.puts("#{cycles} left. #{length(data)} items in this cycle")
    data
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(11)
end

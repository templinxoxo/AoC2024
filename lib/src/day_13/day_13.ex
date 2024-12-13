defmodule Aoc.Day13 do
  @moduledoc """
  Day 13 solutions
  https://adventofcode.com/2024/day/13
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> Enum.map(&solve/1)
    |> calculate_tokens()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  @doc """
  Function solving 2 variable expression
  Input is list of known values: `[a, b, c, d, r1, r2]`
  On example:
    Button A: X+94, Y+34 (xa = 94, ya = 34)
    Button B: X+22, Y+67 (xb = 22, yb = 67)
    Prize: X=8400, Y=5400 (rx = 8400, ry = 5400)

  By clicking button A A-times and button B B-times we can get to the price. This is a simple
  mathematical equation system:
    A * xa + B * xb = rx
    A * ya + B * yb = ry

  from here:
    A = (rx - B * xb) / xa
    B = (ry - A * ya) / yb

  using 1 expression to solve the other one:
    A = (rx * yb - ry * xb) / (xa * yb - xb * ya)

  For the solution to make sense, the result (A and B) must be integers, not fractions.
  If any of the numbers is fraction - returns nil
  otherwise returns tuple with A and B values
  """
  def solve([xa, ya, xb, yb, rx, ry]) do
    a = (rx * yb - ry * xb) / (xa * yb - xb * ya)
    b = (ry - a * ya) / yb

    if not Aoc.Helpers.is_fraction?(a) and not Aoc.Helpers.is_fraction?(b) do
      {a, b}
    else
      nil
    end
  end

  defp calculate_tokens(results) do
    results
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn {a, b} -> a * 3 + b end)
    |> Enum.sum()
  end

  # helpers
  defp parse_input(input) do
    ~r/(?<=(X|Y)(\=|\+))\d*/
    |> Regex.scan(input)
    |> Enum.map(&(&1 |> hd() |> String.to_integer()))
    |> Enum.chunk_every(6, 6, :discard)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(13)
end

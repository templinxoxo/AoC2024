defmodule Aoc.Day07 do
  @moduledoc """
  Day 07 solutions
  https://adventofcode.com/2024/day/07
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> Enum.filter(&equation_valid?(&1, [:sum, :mul]))
    |> calculate_calibration_result()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp equation_valid?({result, numbers}, operators) do
    numbers
    |> produce_equation_combinations(operators)
    |> Enum.any?(&(solve_equation(&1) == result))
  end

  defp produce_equation_combinations([hd | numbers], operators) do
    Enum.reduce(numbers, [[hd]], fn number, combinations ->
      Enum.flat_map(operators, fn operator ->
        Enum.map(combinations, fn combination ->
          [{number, operator} | combination]
        end)
      end)
    end)
    |> Enum.map(&Enum.reverse/1)
  end

  defp solve_equation(equation),
    do: Enum.reduce(equation, fn {b, operator}, a -> calculate(a, b, operator) end)

  defp calculate(a, b, :sum), do: a + b
  defp calculate(a, b, :mul), do: a * b

  # helpers
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(~r/\:|\s/, trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.split(1)
      |> then(fn {[result], numbers} -> {result, numbers} end)
    end)
  end

  defp calculate_calibration_result(data), do:
    data
    |> Enum.map(fn {result, _} -> result end)
    |> Enum.sum()

  defp fetch_data(), do: Aoc.Utils.Api.get_input(07)

end

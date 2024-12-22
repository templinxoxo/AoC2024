defmodule Aoc.Day22 do
  @moduledoc """
  Day 22 solutions
  https://adventofcode.com/2024/day/22
  """
  alias Aoc.Utils.BitwiseXor

  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> Enum.map(& &1 |> IO.inspect() |> generate_secret_numbers(2000))
    |> Enum.sum()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp generate_secret_numbers(secret_number, 0), do: secret_number

  defp generate_secret_numbers(secret_number, iterations_left) do
    secret_number
    |> secret_number_transformation(:mul, 64)
    |> secret_number_transformation(:div, 32)
    |> secret_number_transformation(:mul, 2048)
    |> generate_secret_numbers(iterations_left - 1)
  end

  defp secret_number_transformation(secret_number, transformation, factor) do
    secret_number
    |> transform_by_factor(transformation, factor)
    |> mix(secret_number)
    |> prune()
  end

  defp transform_by_factor(number, :mul, factor), do: number * factor
  defp transform_by_factor(number, :div, factor), do: floor(number / factor)

  def mix(number, secret_number), do: BitwiseXor.perform(number, secret_number)
  @secret_modulo 16_777_216
  def prune(secret_number), do: rem(secret_number, @secret_modulo)

  # helpers
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(22)
end

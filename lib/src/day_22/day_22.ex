defmodule Aoc.Day22 do
  @moduledoc """
  Day 22 solutions
  https://adventofcode.com/2024/day/22
  """
  alias Aoc.Utils.BitwiseXor
  use Memoize

  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> Enum.map(fn secret_number ->
      secret_number
      |> generate_secret_numbers()
      |> hd()
    end)
    |> Enum.sum()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()
    |> Enum.map(fn secret_number ->
      secret_number
      |> generate_secret_numbers()
      |> Enum.reverse()
      |> to_price_fluctuation()
    end)
    # group by fluctuations
    |> List.flatten()
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    # for each fluctuation group, sum prices
    |> Enum.map(fn {fluctuation, prices} ->
      {fluctuation, Enum.sum(prices)}
    end)
    # find the best possible fluctuation and it's price
    |> Enum.max_by(&elem(&1, 1))
    |> IO.inspect(charlists: :as_lists)
    |> elem(1)
  end

  defp to_price_fluctuation(secret_numbers) do
    secret_numbers
    # get price for each secret (ones digit)
    |> Enum.map(&rem(&1, 10))
    # add price fluctuations
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> {b - a, b} end)
    # chunk by 4 into price sequences
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.map(fn sequence ->
      price_fluctuation = Enum.map(sequence, &elem(&1, 0))
      {_, price} = List.last(sequence)

      {price_fluctuation, price}
    end)
    # discard repeated fluctuations
    |> Enum.uniq_by(&elem(&1, 0))
  end

  defmemop generate_secret_numbers(secret_number), permanent: true do
    [secret_number]
    |> IO.inspect(charlists: :as_lists)
    |> generate_secret_numbers(2000)
  end

  defp generate_secret_numbers(secret_numbers_history, iterations)
       when length(secret_numbers_history) > iterations,
       do: secret_numbers_history

  defp generate_secret_numbers([secret_number | _] = secret_numbers_history, iterations) do
    secret_number
    |> get_next_secret_number()
    |> then(&[&1 | secret_numbers_history])
    |> generate_secret_numbers(iterations)
  end

  defmemop get_next_secret_number(secret_number), permanent: true do
    secret_number
    |> secret_number_transformation(:mul, 64)
    |> secret_number_transformation(:div, 32)
    |> secret_number_transformation(:mul, 2048)
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

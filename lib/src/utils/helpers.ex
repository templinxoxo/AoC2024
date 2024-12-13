defmodule Aoc.Helpers do
  @doc """
  Check if the number is a fraction, with a given precision (default 100)
  """
  @fraction_precision 100
  def is_fraction?(number, precision \\ @fraction_precision)
  def is_fraction?(number, _) when is_integer(number), do: false

  def is_fraction?(number, precision) do
    round(number * precision)
    |> rem(precision)
    |> then(&(&1 != 0))
  end
end

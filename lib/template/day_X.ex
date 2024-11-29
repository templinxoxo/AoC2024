defmodule Aoc.Day__DAY__ do
  @moduledoc """
  Day __DAY__ solutions
  https://adventofcode.com/2024/day/__DAY__
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  # helpers
  def fetch_data() do
    day = "__DAY__"
    Aoc.Utils.Api.get_input(day)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
    end)
  end
end

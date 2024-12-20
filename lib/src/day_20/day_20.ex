defmodule Aoc.Day20 do
  @moduledoc """
  Day 20 solutions
  https://adventofcode.com/2024/day/20
  """
  alias Aoc.Day20.Utils
  def execute_part_1(data \\ fetch_data()) do
    data
    |> Utils.parse_input()
    |> then(fn map ->
      map
      |> Utils.bfs()
    end)
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> Utils.parse_input()

    0
  end

  # helpers
  defp fetch_data(), do: Aoc.Utils.Api.get_input(20)
end

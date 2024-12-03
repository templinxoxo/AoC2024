defmodule Aoc.Day03 do
  @moduledoc """
  Day 03 solutions
  https://adventofcode.com/2024/day/03
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> get_mul_commands()
    |> Enum.map(&solve_mul_command/1)
    |> Enum.sum()
  end

  def execute_part_2(data \\ fetch_data()) do
    data

    0
  end

  defp get_mul_commands(data) do
    ~r/mul\(\d{1,3}\,\d{1,3}\)/
    |> Regex.scan(data)
    |> List.flatten()
  end

  defp solve_mul_command(command) do
    ~r/\d+/
    |> Regex.scan(command)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(&Kernel.*/2)
  end

  # helpers
  defp fetch_data(), do: Aoc.Utils.Api.get_input(03)
end

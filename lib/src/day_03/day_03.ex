defmodule Aoc.Day03 do
  @moduledoc """
  Day 03 solutions
  https://adventofcode.com/2024/day/03
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> get_valid_commands()
    |> drop_conditionals()
    |> Enum.map(&solve_mul_command/1)
    |> Enum.sum()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> get_valid_commands()
    |> drop_disabled_commands()
    |> Enum.map(&solve_mul_command/1)
    |> Enum.sum()
  end

  defp get_valid_commands(data) do
    ~r/((don\'t\(\))|(do\(\))|(mul\(\d{1,3}\,\d{1,3}\)))/
    |> Regex.scan(data)
    |> Enum.map(&List.first/1)
  end

  defp drop_conditionals(commands), do: Enum.reject(commands, &(&1 in ["do()", "don't()"]))

  defp drop_disabled_commands(all_commands) do
    all_commands
    |> Enum.reduce([], fn
      # `do` overrides `don't`
      "do()", ["don't()" | commands] -> commands
      # otherwise, do doesn't to anything
      "do()", commands -> commands
      # if the prev element is `don't`, skip current command
      _, ["don't()" | _] = commands -> commands
      # and in case of any other command - just add it to commands list
      command, commands -> [command | commands]
    end)
    |> drop_conditionals()
  end

  defp solve_mul_command(command) do
    ~r/\d+/
    |> Regex.scan(command)
    |> Enum.map(&List.first/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(&Kernel.*/2)
  end

  # helpers
  defp fetch_data(), do: Aoc.Utils.Api.get_input(03)
end

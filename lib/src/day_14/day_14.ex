defmodule Aoc.Day14 do
  @moduledoc """
  Day 14 solutions
  https://adventofcode.com/2024/day/14
  """
  @cycles 100
  @space_size [101, 103]
  def execute_part_1, do: fetch_data() |> execute_part_1(@space_size)

  def execute_part_1(data, space_size) do
    data
    |> parse_input()
    |> Enum.map(&move_in_space(&1, space_size, @cycles))
    |> Enum.group_by(&get_quadrant(&1, space_size))
    |> Map.delete(:middle)
    |> safety_factor()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp move_in_space([[x0, y0], [vx, vy]], [x_max, y_max], cycles) do
    [
      move_by_axis_by_cycles(x0, vx, cycles, x_max),
      move_by_axis_by_cycles(y0, vy, cycles, y_max)
    ]
  end

  defp move_by_axis_by_cycles(start, velocity, cycles, max) do
    start
    |> Kernel.+(velocity * cycles)
    |> rem(max)
    |> case do
      x when x < 0 -> max + x
      x -> x
    end
  end

  defp get_quadrant([x, y], [x_max, y_max]) do
    case {halfway_point(x_max), halfway_point(y_max)} do
      {x_half, y_half} when x < x_half and y < y_half -> :top_left
      {x_half, y_half} when x > x_half and y < y_half -> :top_right
      {x_half, y_half} when x < x_half and y > y_half -> :bottom_left
      {x_half, y_half} when x > x_half and y > y_half -> :bottom_right
      _ -> :middle
    end
  end

  defp halfway_point(integer) do
    integer |> div(2) |> floor()
  end

  defp safety_factor(points_by_quadrant) do
    points_by_quadrant
    |> Enum.map(fn {_, points} -> length(points) end)
    |> Enum.reduce(&Kernel.*/2)
  end

  # helpers
  defp parse_input(input) do
    ~r/(-?)\d+/
    |> Regex.scan(input)
    |> Enum.map(&(&1 |> hd() |> String.to_integer()))
    |> Enum.chunk_every(4, 4, :discard)
    |> Enum.map(&Enum.chunk_every(&1, 2))
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(14)
end

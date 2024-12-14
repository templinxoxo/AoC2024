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

  def execute_part_2, do: fetch_data() |> execute_part_2(@space_size)

  def execute_part_2(data, space_size) do
    data
    |> parse_input()
    |> keep_moving(space_size)
  end

  defp move_in_space([[x0, y0], [vx, vy]], [x_max, y_max], cycles) do
    [
      move_by_axis_by_cycles(x0, vx, cycles, x_max),
      move_by_axis_by_cycles(y0, vy, cycles, y_max)
    ]
  end

  # idea - print to see if any pattern emerges
  # results - starting at 72, with the cycle length of pattern of 101
  # the robots are clustered together near the cycle.
  # so starting at 72 move by step of 101 until the result if found
  # @pattern_length 101
  # @starting_cycle 72

  # This will help you find a x-mass pattern on step 7344
  # next x-mass pattern will be found after 10403, at 17747 step (full pattern repeat)
  @pattern_length 10403
  @starting_cycle 7344
  defp keep_moving(positions, space_size, cycle \\ 7344) do
    positions
    |> Enum.map(&move_in_space(&1, space_size, cycle))
    |> print(space_size, cycle)

    IO.gets("Next one?")
    keep_moving(positions, space_size, cycle + @pattern_length)
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
  defp print(positions, [x_max, y_max], label) do
    0..(y_max - 1)
    |> Enum.each(fn y ->
      0..(x_max - 1)
      |> Enum.map(fn x ->
        if [x, y] in positions do
          "X"
        else
          "."
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    IO.inspect(label)
    positions
  end

  defp parse_input(input) do
    ~r/(-?)\d+/
    |> Regex.scan(input)
    |> Enum.map(&(&1 |> hd() |> String.to_integer()))
    |> Enum.chunk_every(4, 4, :discard)
    |> Enum.map(&Enum.chunk_every(&1, 2))
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(14)
end

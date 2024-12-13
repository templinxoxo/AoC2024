defmodule Aoc.Day13Test do
  use ExUnit.Case

  alias Aoc.Day13, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400

  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176

  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450

  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 480
  end

  test "execute_part_2/1" do
    Subject.execute_part_2(@test_data)
    |> IO.puts()
  end
end

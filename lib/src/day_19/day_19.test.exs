defmodule Aoc.Day19Test do
  use ExUnit.Case

  alias Aoc.Day19, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  r, wr, b, g, bwu, rb, gb, br

  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 6
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

defmodule Aoc.Day01Test do
  use ExUnit.Case

  alias Aoc.Day01, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 11
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 31
  end
end

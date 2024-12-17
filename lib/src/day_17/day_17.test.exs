defmodule Aoc.Day17Test do
  use ExUnit.Case

  alias Aoc.Day17, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data_1 """
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data_1)

    assert result == "4,6,3,5,6,3,5,2,1,0"
  end

  @test_data_2 """
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,3,5,4,3,0
  """

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data_2)

    assert result == 117_440
  end
end

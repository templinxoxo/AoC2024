defmodule Aoc.Day14Test do
  use ExUnit.Case

  alias Aoc.Day14, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  p=0,4 v=3,-3
  p=6,3 v=-1,-3
  p=10,3 v=-1,2
  p=2,0 v=2,-1
  p=0,0 v=1,3
  p=3,0 v=-2,-2
  p=7,6 v=-1,-3
  p=3,0 v=-1,-2
  p=9,3 v=2,3
  p=7,3 v=-1,2
  p=2,4 v=2,-3
  p=9,5 v=-3,-3
  """
  @space_size [11, 7]

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data, @space_size)

    assert result == 12
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

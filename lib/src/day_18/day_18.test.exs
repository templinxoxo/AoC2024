defmodule Aoc.Day18Test do
  use ExUnit.Case

  alias Aoc.Day18, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  5,4
  4,2
  4,5
  3,0
  2,1
  6,3
  2,4
  1,5
  0,6
  3,3
  2,6
  5,1
  1,2
  5,5
  2,5
  6,5
  1,4
  0,4
  6,4
  1,1
  6,1
  1,0
  0,5
  1,6
  2,0
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data, {6, 6}, 12)

    assert result == 22
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data, {6, 6})

    assert result == {6, 1}
  end
end

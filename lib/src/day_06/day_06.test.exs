defmodule Aoc.Day06Test do
  use ExUnit.Case

  alias Aoc.Day06, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 41
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

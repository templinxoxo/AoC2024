defmodule Aoc.Day02Test do
  use ExUnit.Case

  alias Aoc.Day02, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 2
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

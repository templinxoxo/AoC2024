defmodule Aoc.Day09Test do
  use ExUnit.Case

  alias Aoc.Day09, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  2333133121414131402
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 1928
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

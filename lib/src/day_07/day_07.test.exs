defmodule Aoc.Day07Test do
  use ExUnit.Case

  alias Aoc.Day07, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 3749
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

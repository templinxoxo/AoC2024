defmodule Aoc.Day22Test do
  use ExUnit.Case

  alias Aoc.Day22, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data_1 """
  1
  10
  100
  2024
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data_1)

    assert result == 37_327_623
  end

  @test_data_2 """
  1
  2
  3
  2024
  """

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data_2)

    assert result == 23
  end
end

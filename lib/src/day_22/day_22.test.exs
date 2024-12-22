defmodule Aoc.Day22Test do
  use ExUnit.Case

  alias Aoc.Day22, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  1
  10
  100
  2024
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 37_327_623
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

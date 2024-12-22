defmodule Aoc.Day21Test do
  use ExUnit.Case

  alias Aoc.Day21, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  029A
  980A
  179A
  456A
  379A
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 126_384
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

defmodule Aoc.Day03Test do
  use ExUnit.Case

  alias Aoc.Day03, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 161
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

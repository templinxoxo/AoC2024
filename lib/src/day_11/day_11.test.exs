defmodule Aoc.Day11Test do
  use ExUnit.Case

  alias Aoc.Day11, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  125 17
  """

  test "execute/1 - short example" do
    result = Subject.execute(@test_data, 6)

    assert result == 22
  end

  test "execute/1 - part 1" do
    result = Subject.execute(@test_data, 25)

    assert result == 55312
  end

  # test "execute/1 - part 2" do
  #   result = Subject.execute(@test_data)

  #   assert result == 0
  # end
end

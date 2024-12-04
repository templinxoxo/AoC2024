defmodule Aoc.Day04Test do
  use ExUnit.Case

  alias Aoc.Day04, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 18
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 9
  end
end

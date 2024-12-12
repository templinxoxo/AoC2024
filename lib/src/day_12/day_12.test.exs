defmodule Aoc.Day12Test do
  use ExUnit.Case

  alias Aoc.Day12, as: Subject

  @test_data_1 """
  AAAA
  BBCD
  BBCC
  EEEC
  """

  test "execute_part_1/1 - data 1" do
    result = Subject.execute_part_1(@test_data_1)

    assert result == 140
  end

  @test_data_2 """
  OOOOO
  OXOXO
  OOOOO
  OXOXO
  OOOOO
  """

  test "execute_part_1/1 - data 2" do
    result = Subject.execute_part_1(@test_data_2)

    assert result == 772
  end

  @test_data_3 """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  test "execute_part_1/1 - data 3" do
    result = Subject.execute_part_1(@test_data_3)

    assert result == 1930
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data_3)

    assert result == 0
  end
end

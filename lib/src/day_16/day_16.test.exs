defmodule Aoc.Day16Test do
  use ExUnit.Case

  alias Aoc.Day16, as: Subject

  @test_data_1 """
  ###############
  #.......#....E#
  #.#.###.#.###.#
  #.....#.#...#.#
  #.###.#####.#.#
  #.#.#.......#.#
  #.#.#####.###.#
  #...........#.#
  ###.#.#####.#.#
  #...#.....#.#.#
  #.#.#.###.#.#.#
  #.....#...#.#.#
  #.###.#.#.#.#.#
  #S..#.....#...#
  ###############
  """

  test "execute_part_1/1 - input 1" do
    result = Subject.execute_part_1(@test_data_1)

    assert result == 7036
  end

  @test_data_2 """
  #################
  #...#...#...#..E#
  #.#.#.#.#.#.#.#.#
  #.#.#.#...#...#.#
  #.#.#.#.###.#.#.#
  #...#.#.#.....#.#
  #.#.#.#.#.#####.#
  #.#...#.#.#.....#
  #.#.#####.#.###.#
  #.#.#.......#...#
  #.#.###.#####.###
  #.#.#...#.....#.#
  #.#.#.#####.###.#
  #.#.#.........#.#
  #.#.#.#########.#
  #S#.............#
  #################
  """

  test "execute_part_1/1 - input 2" do
    result = Subject.execute_part_1(@test_data_2)

    assert result == 11048
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data_2)

    assert result == 64
  end
end

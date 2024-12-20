defmodule Aoc.Day20Test do
  use ExUnit.Case

  alias Aoc.Day20, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  ###############
  #...#...#.....#
  #.#.#.#.#.###.#
  #S#...#.#.#...#
  #######.#.#.###
  #######.#.#...#
  #######.#.###.#
  ###..E#...#...#
  ###.#######.###
  #...###...#...#
  #.#####.#.###.#
  #.#...#.#.#...#
  #.#.#.#.#.#.###
  #...#...#...###
  ###############
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == %{
             2 => 14,
             4 => 14,
             6 => 2,
             8 => 4,
             10 => 2,
             12 => 3,
             20 => 1,
             36 => 1,
             38 => 1,
             40 => 1,
             64 => 1
           }
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

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

  test "execute/1 - cheat distance 2" do
    result = Subject.execute(@test_data, 2) |> Subject.filter_cheats_by_saved_distance(2)

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

  test "execute/1 - cheat distance 20" do
    result = Subject.execute(@test_data, 20) |> Subject.filter_cheats_by_saved_distance(50)

    assert result == %{
             50 => 32,
             52 => 31,
             54 => 29,
             56 => 39,
             58 => 25,
             60 => 23,
             62 => 20,
             64 => 19,
             66 => 12,
             68 => 14,
             70 => 12,
             72 => 22,
             74 => 4,
             76 => 3
           }
  end
end

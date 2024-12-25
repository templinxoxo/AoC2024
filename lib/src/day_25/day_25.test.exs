defmodule Aoc.Day25Test do
  use ExUnit.Case

  alias Aoc.Day25, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  #####
  .####
  .####
  .####
  .#.#.
  .#...
  .....

  #####
  ##.##
  .#.##
  ...##
  ...#.
  ...#.
  .....

  .....
  #....
  #....
  #...#
  #.#.#
  #.###
  #####

  .....
  .....
  #.#..
  ###..
  ###.#
  ###.#
  #####

  .....
  .....
  .....
  #....
  #.#..
  #.#.#
  #####
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 3
  end
end

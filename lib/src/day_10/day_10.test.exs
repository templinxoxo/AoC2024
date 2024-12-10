defmodule Aoc.Day10Test do
  use ExUnit.Case

  alias Aoc.Day10, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  test "execute_part_1/1 - small input" do
    """
    0123
    1234
    8765
    9876
    """
    |> Subject.execute_part_1()
    |> then(fn result ->
      assert result == 1
    end)
  end

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 36
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 81
  end
end

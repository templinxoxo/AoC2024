defmodule Aoc.Day23Test do
  use ExUnit.Case

  alias Aoc.Day23, as: Subject

  # replace with test data from the AoC puzzle page
  @test_data """
  kh-tc
  qp-kh
  de-cg
  ka-co
  yn-aq
  qp-ub
  cg-tb
  vc-aq
  tb-ka
  wh-tc
  yn-cg
  kh-ub
  ta-co
  de-co
  tc-td
  tb-wq
  wh-td
  ta-ka
  td-qp
  aq-cg
  wq-ub
  ub-vc
  de-ta
  wq-aq
  wq-vc
  wh-yn
  ka-de
  kh-ta
  co-tc
  wh-qp
  tb-vc
  td-yn
  """

  test "execute_part_1/1" do
    result = Subject.execute_part_1(@test_data)

    assert result == 7
  end

  test "execute_part_2/1" do
    result = Subject.execute_part_2(@test_data)

    assert result == 0
  end
end

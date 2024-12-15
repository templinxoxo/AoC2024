defmodule Aoc.Day15.Utils do
  @moduledoc """
  Day 15 solutions
  https://adventofcode.com/2024/day/15
  """
  def parse_input(input) do
    [map, movements] = String.split(input, "\n\n", trim: true)

    movements = movements |> String.replace("\n", "") |> String.split("", trim: true)

    map =
      map
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    {map, movements}
  end

  def change_position({x, y}, "<"), do: {x - 1, y}
  def change_position({x, y}, ">"), do: {x + 1, y}
  def change_position({x, y}, "^"), do: {x, y - 1}
  def change_position({x, y}, "v"), do: {x, y + 1}

  def starting_position(map) do
    map
    |> list_coordinates()
    |> Enum.find(&is_elem?(&1, "@"))
    |> then(fn {_, {x, y}} -> {x, y} end)
  end

  def get_at(map, {x, y}) do
    map
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def replace_at(map, {x, y}, element) do
    List.update_at(map, y, fn row ->
      List.replace_at(row, x, element)
    end)
  end

  def gps_score(map) do
    map
    |> list_coordinates()
    |> Enum.filter(&(is_elem?(&1, "O") or is_elem?(&1, "[")))
    |> Enum.map(fn {_, {x, y}} -> x + 100 * y end)
    |> Enum.sum()
  end

  def list_coordinates(map) do
    map
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {cell, x} ->
        {cell, {x, y}}
      end)
    end)
  end

  def is_elem?({cell, _}, elem), do: cell == elem
end

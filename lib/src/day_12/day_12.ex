defmodule Aoc.Day12 do
  @moduledoc """
  Day 12 solutions
  https://adventofcode.com/2024/day/12
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> parse_input()
    |> with_plot_coordinates()
    |> group_by_plant()
    |> Enum.map(fn {_cell, plot_coordinates} ->
      plot_coordinates
      |> split_into_regions()
      |> Enum.map(fn region ->
        area = calculate_area(region)

        region
        |> get_fence_coordinates()
        |> calculate_perimeter()
        |> calculate_cost(area)
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> parse_input()

    0
  end

  defp split_into_regions(plot_coordinate, areas \\ [])
  defp split_into_regions([], areas), do: areas

  defp split_into_regions([plot_coordinate | plot_coordinates], areas) do
    {area_coordinates, non_area_coordinates} =
      group_by_region([plot_coordinate], plot_coordinates, [])

    areas = areas ++ [area_coordinates]

    split_into_regions(non_area_coordinates, areas)
  end

  defp group_by_region([], possible_coordinates, area_coordinates),
    do: {area_coordinates, possible_coordinates -- area_coordinates}

  defp group_by_region(current_coordinates, possible_coordinates, area_coordinates) do
    area_coordinates = Enum.concat(area_coordinates, current_coordinates)

    current_coordinates
    |> Enum.flat_map(&get_neighbors(&1))
    |> Enum.uniq()
    |> Enum.reject(&(&1 in area_coordinates))
    |> Enum.filter(&(&1 in possible_coordinates))
    |> group_by_region(possible_coordinates, area_coordinates)
  end

  defp get_fence_coordinates(area_coordinates) do
    Enum.map(area_coordinates, fn plot ->
      plot
      |> get_neighbors()
      |> Enum.reject(&(&1 in area_coordinates))
    end)
  end

  defp calculate_perimeter(fence_coordinates),
    do: fence_coordinates |> List.flatten() |> Enum.count()

  defp calculate_area(region_coordinates), do: Enum.count(region_coordinates)
  defp calculate_cost(perimeter, area), do: perimeter * area

  defp get_neighbors({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  # helpers
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp with_plot_coordinates(map) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {plant, x} -> {plant, {x, y}} end)
    end)
  end

  defp group_by_plant(map) do
    map
    |> List.flatten()
    |> Enum.group_by(
      fn {plant, _plot_coordinates} -> plant end,
      fn {_plant, plot_coordinates} -> plot_coordinates end
    )
  end

  defp fetch_data(), do: Aoc.Utils.Api.get_input(12)
end

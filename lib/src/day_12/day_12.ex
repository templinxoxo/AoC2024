defmodule Aoc.Day12 do
  @moduledoc """
  Day 12 solutions
  https://adventofcode.com/2024/day/12
  """
  def execute_part_1(data \\ fetch_data()) do
    data
    |> as_grouped_regions()
    |> Enum.map(fn {_cell, region} ->
      area = calculate_area(region)

      region
      |> get_fence_coordinates()
      |> calculate_perimeter()
      |> calculate_cost(area)
    end)
    |> Enum.sum()
  end

  def execute_part_2(data \\ fetch_data()) do
    data
    |> as_grouped_regions()
    |> Enum.map(fn {_cell, region} ->
      area = calculate_area(region)

      region
      |> get_fence_coordinates()
      |> List.flatten()
      |> concat_adjoining_fences()
      |> calculate_perimeter()
      |> calculate_cost(area)
    end)
    |> Enum.sum()
  end

  defp as_grouped_regions(raw_data) do
    raw_data
    |> parse_input()
    |> with_plot_coordinates()
    |> group_by_plant()
    |> Enum.flat_map(fn {cell, plot_coordinates} ->
      plot_coordinates
      |> split_into_regions()
      |> Enum.map(&{cell, &1})
    end)
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
    |> Enum.flat_map(&get_neighbors/1)
    |> Enum.uniq()
    |> Enum.reject(&(&1 in area_coordinates))
    |> Enum.filter(&(&1 in possible_coordinates))
    |> group_by_region(possible_coordinates, area_coordinates)
  end

  defp get_fence_coordinates(area_coordinates) do
    Enum.map(area_coordinates, fn plot ->
      plot
      |> get_neighbors(with_sides: true)
      |> Enum.reject(fn {x, y, _} -> {x, y} in area_coordinates end)
    end)
  end

  defp concat_adjoining_fences(fence_coordinates) do
    fence_coordinates
    |> Enum.group_by(
      fn
        {x, _y, side} when side in [:left, :right] -> {nil, x, side}
        {_x, y, side} when side in [:up, :down] -> {y, nil, side}
      end,
      fn
        {_x, y, side} when side in [:left, :right] -> y
        {x, _y, side} when side in [:up, :down] -> x
      end
      # fn
      #   {_x, y, side} when side in [:left, :right] -> {nil, y, side}
      #   {x, _y, side} when side in [:up, :down] -> {x, nil, side}
      # end,
      # fn
      #   {x, _y, side} when side in [:left, :right] -> x
      #   {_x, y, side} when side in [:up, :down] -> y
      # end
    )
    |> Enum.flat_map(fn
      {{x, nil, side}, coordinates} ->
        coordinates
        |> into_ranges()
        |> Enum.map(&{x, &1, side})

      {{nil, y, side}, coordinates} ->
        coordinates
        |> into_ranges()
        |> Enum.map(&{&1, y, side})
    end)
  end

  defp into_ranges(numbers) do
    numbers
    |> Enum.sort()
    |> Enum.chunk_while(
      [],
      fn
        elem, [] -> {:cont, [elem]}
        elem, [last_elem | _] = acc when last_elem + 1 == elem -> {:cont, [elem | acc]}
        elem, acc -> {:cont, acc, [elem]}
      end,
      fn acc -> {:cont, acc, nil} end
    )
    |> Enum.map(fn range ->
      List.last(range)..List.first(range)
    end)
  end

  defp calculate_perimeter(fence_coordinates),
    do: fence_coordinates |> List.flatten() |> Enum.count()

  defp calculate_area(region_coordinates), do: Enum.count(region_coordinates)
  defp calculate_cost(perimeter, area), do: perimeter * area

  defp get_neighbors(_point, opts \\ [])

  defp get_neighbors({x, y}, with_sides: true),
    do: [{x + 1, y, :right}, {x - 1, y, :left}, {x, y + 1, :down}, {x, y - 1, :up}]

  defp get_neighbors({x, y}, _), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

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

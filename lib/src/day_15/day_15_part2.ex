defmodule Aoc.Day15.Part2 do
  @moduledoc """
  Day 15 solutions
  https://adventofcode.com/2024/day/15
  """
  alias Aoc.Day15.Utils

  def execute(data \\ fetch_data()) do
    {map, movements} = data |> Utils.parse_input()

    map = extend_cells(map)
    starting_position = Utils.starting_position(map)
    map = Utils.replace_at(map, starting_position, ".")

    starting_position
    |> move(movements, map)
    |> Utils.gps_score()
  end

  defp move(_current_position, [], map), do: map

  defp move(current_position, [move | movements], map) do
    destination = Utils.change_position(current_position, move)

    case Utils.get_at(map, destination) do
      "#" ->
        move(current_position, movements, map)

      "." ->
        move(destination, movements, map)

      _ ->
        try_pushing(current_position, move, map, movements)
    end
  end

  defp try_pushing(current_position, direction, map, movements) do
    case move_boxes([{current_position, "."}], direction, map) do
      {:ok, updated_map} ->
        current_position |> Utils.change_position(direction) |> move(movements, updated_map)

      {:error, :run_into_a_wall} ->
        move(current_position, movements, map)
    end
  end

  defp move_boxes([], _, map), do: {:ok, map}
  # boxes: [{position, element}]
  # direction: "<" | ">" | "^" | "v"
  defp move_boxes([{box_position, box_element} | other_boxes], direction, map) do
    neighbor_box = get_neighboring_box(box_position, direction, map)
    {neighboring_box_position, neighboring_box_fragment} = neighbor_box

    case neighboring_box_fragment do
      "#" ->
        {:error, :run_into_a_wall}

      "." ->
        map = Utils.replace_at(map, neighboring_box_position, box_element)
        move_boxes(other_boxes, direction, map)

      _ ->
        box_extension = maybe_extend_box(neighbor_box, direction, map)

        map =
          box_extension
          |> Enum.reduce(map, fn {position, _element}, map ->
            Utils.replace_at(map, position, ".")
          end)
          |> Utils.replace_at(neighboring_box_position, box_element)

        other_boxes
        |> Enum.concat([neighbor_box])
        |> Enum.concat(box_extension)
        |> move_boxes(direction, map)
    end
  end

  defp get_neighboring_box(position, direction, map) do
    destination = Utils.change_position(position, direction)
    destination_element = Utils.get_at(map, destination)

    {destination, destination_element}
  end

  defp maybe_extend_box(_box, direction, _map) when direction in ["<", ">"] do
    []
  end

  defp maybe_extend_box({position, element}, _direction, map) do
    case element do
      "]" -> [get_neighboring_box(position, "<", map)]
      "[" -> [get_neighboring_box(position, ">", map)]
    end
  end

  # helpers
  defp extend_cells(map) do
    Enum.map(map, fn row -> Enum.flat_map(row, &extend_cell/1) end)
  end

  defp extend_cell("#"), do: ["#", "#"]
  defp extend_cell("O"), do: ["[", "]"]
  defp extend_cell("."), do: [".", "."]
  defp extend_cell("@"), do: ["@", "."]

  defp fetch_data(), do: Aoc.Utils.Api.get_input(15)
end

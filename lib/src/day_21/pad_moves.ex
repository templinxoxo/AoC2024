defmodule Aoc.Day21.PadMoves do
  def all_possible_moves(pad) do
    pad
    # group pad keys into all possible 2 key pairs
    |> List.flatten()
    |> into_pairs()
    |> Enum.map(fn {start, target} ->
      # for each pair
      start
      # get manhattan directions movements (along x and y axis)
      |> manhattan_movement(target, pad)
      # from those directions get all possible permutations
      |> permutations()
      # deduplicate?
      # |> Enum.uniq()
      |> then(fn paths -> {{start, target}, paths} end)
    end)
    # turn into a map with {start, target} as key and paths as value
    |> then(fn moves ->
      moves_map = Map.new(moves)

      moves
      # remove path to or from empty space
      |> Enum.reject(fn {{start, target}, _} -> start == " " or target == " " end)
      |> Enum.map(fn {{start, _} = key, paths} ->
        path_to_nil = moves_map |> Map.get({start, " "}) |> List.first()

        # remove paths that starts with the literal path to nil from current element
        paths = Enum.reject(paths, fn path -> List.starts_with?(path, path_to_nil) end)

        {key, paths}
      end)
    end)
    # into map again
    |> Map.new()
  end

  defp into_pairs(elements) do
    Enum.flat_map(elements, fn element ->
      elements
      |> Enum.reject(&(&1 == element))
      |> Enum.map(&{element, &1})
    end)
  end

  @vertical_direction {1, "v", "^"}
  @horizontal_direction {0, ">", "<"}
  defp manhattan_movement(start, target, pad) do
    start_coordinates = find_coordinates(pad, start)
    target_coordinates = find_coordinates(pad, target)

    vertical_movement = axis_movement(start_coordinates, target_coordinates, @vertical_direction)

    horizontal_movement =
      axis_movement(start_coordinates, target_coordinates, @horizontal_direction)

    vertical_movement ++ horizontal_movement
  end

  defp find_coordinates(pad, element) do
    pad
    |> pad_coordinates()
    |> Enum.find(fn {_coordinates, elem} -> elem == element end)
    |> case do
      nil -> nil
      {coordinates, _} -> coordinates
    end
  end

  defp axis_movement(
         start_coordinates,
         target_coordinates,
         {coordinate_index, direction_pos, direction_neg}
       ) do
    distance =
      elem(target_coordinates, coordinate_index) - elem(start_coordinates, coordinate_index)

    direction = if distance > 0, do: direction_pos, else: direction_neg

    List.duplicate(direction, abs(distance))
  end

  defp permutations(list) do
    list
    |> Enum.uniq()
    |> case do
      [_] ->
        [list]

      elements ->
        Enum.flat_map(elements, fn element ->
          list
          |> List.delete(element)
          |> permutations()
          |> Enum.map(&[element | &1])
        end)
    end
  end

  defp pad_coordinates(pad) do
    pad
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {element, x} -> {{x, y}, element} end)
    end)
  end
end

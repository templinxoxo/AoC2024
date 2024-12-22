defmodule Aoc.Utils.BitwiseXor do
  def perform(a, b) do
    binary_a = to_binary(a)
    binary_b = to_binary(b)

    bits = [binary_a, binary_b] |> Enum.map(&length/1) |> Enum.max()

    -bits..-1
    |> Enum.map(fn bit_index ->
      a_bit = Enum.at(binary_a, bit_index, 0)
      b_bit = Enum.at(binary_b, bit_index, 0)

      xor(a_bit, b_bit)
    end)
    |> to_int()
  end

  defp xor(1, 0), do: 1
  defp xor(0, 1), do: 1
  defp xor(_, _), do: 0

  # binary conversion
  defp to_binary(number),
    do:
      Integer.to_string(number, 2)
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1))

  defp to_int(binary), do: binary |> Enum.join("") |> String.to_integer(2)
end

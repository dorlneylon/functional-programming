defmodule Problem26Modular do
  @moduledoc """
  Problem 26: Reciprocal cycles using modular implementation
  """

  def problem_26 do
    1..999
    |> Enum.map(&{&1, cycle_length(&1)})
    |> Enum.max_by(fn {_, length} -> length end)
    |> elem(0)
  end

  defp cycle_length(den) do
    remainders = Stream.iterate(1, &(&1 * 10))
    remainders
    |> Stream.map(&rem(&1, den))
    |> find_cycle_length(%{}, 0)
  end

  defp find_cycle_length(stream, seen, count) do
    stream
    |> Enum.reduce_while({seen, count}, fn rem, {seen, count} ->
      if Map.has_key?(seen, rem) do
        {:halt, count}
      else
        {:cont, {Map.put(seen, rem, true), count + 1}}
      end
    end)
  end
end

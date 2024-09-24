defmodule Problem26Mapping do
  @moduledoc """
  Problem 26: Reciprocal cycles using mapping
  """

  def problem do
    1..999
    |> Enum.map(&{&1, cycle_length(&1)})
    |> Enum.max_by(fn {_, length} -> length end)
    |> elem(0)
  end

  defp cycle_length(den) do
    Stream.iterate(1, &(&1 * 10))
    |> Stream.map(&rem(&1, den))
    |> Enum.reduce_while({%{}, 0}, fn rem, {seen, count} ->
      if Map.has_key?(seen, rem) do
        {:halt, count}
      else
        {:cont, {Map.put(seen, rem, true), count + 1}}
      end
    end)
  end
end

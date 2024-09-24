defmodule Problem26Comprehension do
  @moduledoc """
  Problem 26: Reciprocal cycles using list comprehension
  """

  def problem do
    for d <- 1..999, reduce: {0, 0} do
      {max_d, max_len} ->
        len = cycle_length(d)
        if len > max_len, do: {d, len}, else: {max_d, max_len}
    end
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

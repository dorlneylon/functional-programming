defmodule Problem26TailRecursion do
  @moduledoc """
  Problem 26: Reciprocal cycles using tail recursion
  """

  def problem do
    1..999
    |> Enum.map(&{&1, cycle_length(1, &1, %{}, 0)})
    |> Enum.max_by(fn {_, length} -> length end)
    |> elem(0)
  end

  defp cycle_length(_, 0, _, _), do: 0
  defp cycle_length(_, _, seen, count) when map_size(seen) > 1000, do: count

  defp cycle_length(num, den, seen, count) do
    rem = rem(num, den)

    if Map.has_key?(seen, rem) do
      count
    else
      cycle_length(rem * 10, den, Map.put(seen, rem, true), count + 1)
    end
  end
end

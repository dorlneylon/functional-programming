defmodule Problem26SimpleRecursion do
  @moduledoc """
  Problem 26: Reciprocal cycles using simple recursion
  """

  def problem_26 do
    1..999
    |> Enum.map(&{&1, cycle_length(1, &1, [], 0)})
    |> Enum.max_by(fn {_, length} -> length end)
    |> elem(0)
  end

  defp cycle_length(_, 0, _, _), do: 0
  defp cycle_length(_, _, seen, count) when length(seen) > 1000, do: count

  defp cycle_length(num, den, seen, count) do
    rem = rem(num, den)
    if rem in seen do
      count
    else
      cycle_length(rem * 10, den, [rem | seen], count + 1)
    end
  end
end

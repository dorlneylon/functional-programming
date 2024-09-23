defmodule Problem5Comprehension do
  @moduledoc """
  Problem 5: Smallest multiple using list comprehension
  """

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(a, b), do: div(a * b, gcd(a, b))

  def problem_5 do
    for n <- 1..20, reduce: 1 do
      acc -> lcm(acc, n)
    end
  end
end

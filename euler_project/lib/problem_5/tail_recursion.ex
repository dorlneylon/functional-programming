defmodule Problem5TailRecursion do
  @moduledoc """
  Euler Project problems solved using tail recursion.
  """
  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(a, b), do: div(a * b, gcd(a, b))

  def problem do
    lcm_tail(1, 2, 20)
  end

  defp lcm_tail(current_lcm, current, limit) when current > limit, do: current_lcm

  defp lcm_tail(current_lcm, current, limit) do
    lcm_tail(lcm(current_lcm, current), current + 1, limit)
  end
end

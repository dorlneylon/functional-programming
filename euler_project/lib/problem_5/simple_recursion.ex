defmodule Problem5SimpleRecursion do
  @moduledoc """
  Problem 5: Smallest multiple
  """

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(a, b), do: div(a * b, gcd(a, b))

  def problem do
    Enum.reduce(1..20, &lcm/2)
  end
end

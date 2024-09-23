defmodule Problem5Mapping do
  @moduledoc """
  Problem 5: Smallest multiple using mapping
  """

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(a, b), do: div(a * b, gcd(a, b))

  def problem_5 do
    1..20
    # task constraints, could be removed
    |> Enum.map(& &1)
    |> Enum.reduce(&lcm/2)
  end
end
defmodule Problem5Modular do
  @moduledoc """
  Problem 5: Smallest multiple
  """

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(a, b), do: div(a * b, gcd(a, b))

  def problem do
    Stream.iterate(1, &(&1 + 1))
    |> Enum.take(20)
    |> Enum.reduce(1, fn x, acc -> lcm(x, acc) end)
  end
end

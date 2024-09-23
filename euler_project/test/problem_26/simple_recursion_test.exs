defmodule Problem26SimpleRecursionTest do
  @moduledoc """
  Test for Problem 26: Reciprocal cycles using simple recursion
  """

  use ExUnit.Case
  doctest Problem26SimpleRecursion

  test "problem_26" do
    assert Problem26SimpleRecursion.problem_26() == 983
  end
end

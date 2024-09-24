defmodule Problem26TailRecursionTest do
  @moduledoc """
  Test for Problem 26: Reciprocal cycles using tail recursion
  """
  use ExUnit.Case
  doctest Problem26TailRecursion

  test "problem" do
    assert Problem26TailRecursion.problem() == 983
  end
end

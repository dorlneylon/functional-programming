defmodule Problem5TailRecursionTest do
  @moduledoc """
  Test for Problem 5: Smallest multiple
  """
  use ExUnit.Case
  doctest Problem5TailRecursion

  test "problem_5" do
    assert Problem5TailRecursion.problem_5() == 232_792_560
  end
end

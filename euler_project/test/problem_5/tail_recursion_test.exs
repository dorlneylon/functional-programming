defmodule Problem5TailRecursionTest do
  @moduledoc """
  Test for Problem 5: Smallest multiple
  """
  use ExUnit.Case
  doctest Problem5TailRecursion

  test "problem" do
    assert Problem5TailRecursion.problem() == 232_792_560
  end
end

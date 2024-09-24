defmodule Problem5SimpleRecursionTest do
  @moduledoc """
  Test for Problem 5: Smallest multiple
  """
  use ExUnit.Case
  doctest Problem5SimpleRecursion

  test "problem" do
    assert Problem5SimpleRecursion.problem() == 232_792_560
  end
end

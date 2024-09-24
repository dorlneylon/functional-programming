defmodule Problem26ComprehensionTest do
  @moduledoc """
  Test for Problem 26: Reciprocal cycles
  """
  use ExUnit.Case
  doctest Problem26Comprehension

  test "problem" do
    assert Problem26Comprehension.problem() == 983
  end
end

defmodule Problem5ComprehensionTest do
  @moduledoc """
  Test for Problem 5: Smallest multiple using list comprehension
  """
  use ExUnit.Case
  doctest Problem5Comprehension

  test "problem_5" do
    assert Problem5Comprehension.problem_5() == 232_792_560
  end
end

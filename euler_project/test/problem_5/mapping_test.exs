defmodule Problem5MappingTest do
  @moduledoc """
  Test for Problem 5: Smallest multiple using mapping
  """
  use ExUnit.Case
  doctest Problem5Mapping

  test "problem_5" do
    assert Problem5Mapping.problem_5() == 232_792_560
  end
end

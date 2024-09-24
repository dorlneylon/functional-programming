defmodule Problem26MappingTest do
  @moduledoc """
  Test for Problem 26: Reciprocal cycles
  """
  use ExUnit.Case
  doctest Problem26Mapping

  test "problem" do
    assert Problem26Mapping.problem() == 983
  end
end

defmodule Problem5MappingTest do
  @moduledoc """
  Test for Problem 5: Smallest multiple using mapping
  """
  use ExUnit.Case
  doctest Problem5Mapping

  test "problem" do
    assert Problem5Mapping.problem() == 232_792_560
  end
end

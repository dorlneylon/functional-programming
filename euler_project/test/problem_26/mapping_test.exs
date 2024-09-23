defmodule Problem26MappingTest do
  use ExUnit.Case
  doctest Problem26Mapping

  test "problem_26" do
    assert Problem26Mapping.problem_26() == 983
  end
end

defmodule Problem26ModularTest do
  @moduledoc """
  Test for Problem 26: Reciprocal cycles
  """
  use ExUnit.Case
  doctest Problem26Modular

  test "problem" do
    assert Problem26Modular.problem() == 983
  end
end

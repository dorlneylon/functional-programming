defmodule Problem5ModularTest do
  @moduledoc """
  Test for Problem 5: Smallest multiple
  """
  use ExUnit.Case
  doctest Problem5Modular

  test "problem" do
    assert Problem5Modular.problem() == 232_792_560
  end
end

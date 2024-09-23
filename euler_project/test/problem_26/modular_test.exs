defmodule Problem26ModularTest do
  use ExUnit.Case
  doctest Problem26Modular

  test "problem_26" do
    assert Problem26Modular.problem_26() == 983
  end
end

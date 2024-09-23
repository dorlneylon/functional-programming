defmodule Mix.Tasks.ExternalScriptProblem26Test do
  @moduledoc """
  Test for Problem 5: Smallest multiple using external script
  """
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Mix.Tasks.RunExternalScript

  test "problem_26" do
    script_path = "problem_26/external.sh"

    output =
      capture_io(fn ->
        RunExternalScript.run([script_path])
      end)

    assert output =~ "expected output from the script"
  end
end

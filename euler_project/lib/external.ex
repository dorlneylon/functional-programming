defmodule Mix.Tasks.RunExternalScript do
  @moduledoc """
  Run an external script solving Euler problems
  """
  use Mix.Task

  @shortdoc "Runs a shell script"
  def run([script_path]) do
    {output, exit_code} = System.cmd("sh", [script_path])

    if exit_code == 0 do
      IO.puts(output)
      output
    else
      raise "Script failed with exit code #{exit_code}: #{output}"
    end
  end
end

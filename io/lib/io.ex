defmodule Io do
  @moduledoc """
  Io module for running the interpolation algorithms.
  """

  def main(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        switches: [
          algorithms: :string,
          frequency: :integer
        ],
        aliases: [
          a: :algorithms,
          f: :frequency
        ]
      )

    algorithms = parse_algorithms(opts[:algorithms] || "linear")
    frequency = opts[:frequency] || 1

    output_pid = spawn(Io.Cli.Outputs, :start, [])

    alg_pids =
      Enum.map(algorithms, fn alg ->
        case alg do
          :linear ->
            spawn(Io.LinearInterpolation, :start, [output_pid, frequency])

          :lagrange ->
            spawn(Io.LagrangeInterpolation, :start, [output_pid, frequency])

          _ ->
            IO.puts("Unknown algorithm: #{alg}")
            nil
        end
      end)
      |> Enum.filter(& &1)

    Io.Cli.Inputs.start(alg_pids)
  end

  defp parse_algorithms(algo_str) do
    algo_str
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.downcase/1)
    |> Enum.map(&String.to_atom/1)
  end
end

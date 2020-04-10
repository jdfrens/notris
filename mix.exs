defmodule Notris.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
  defp aliases do
    [
      all_tests: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
      ]
    ]
  end

  defp deps do
    []
  defp preferred_cli_env do
    [
      all_tests: :test,
    ]
  end
end

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
        "credo --strict",
      ]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
    ]
  end

  defp preferred_cli_env do
    [
      all_tests: :test,
    ]
  end
end

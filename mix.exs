defmodule Notris.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      version: "0.1.0",
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      preferred_cli_env: preferred_cli_env(),
      test_coverage: [tool: ExCoveralls],
      releases: releases()
    ]
  end

  defp aliases do
    [
      all_tests: [
        "format --check-formatted",
        "compile --force --warnings-as-errors",
        "credo --strict",
        "coveralls --umbrella --raise",
        "dialyzer --list-unused-filters"
      ]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  # NOTE: skipping :no_*, :underspecs, :overspecs, :specdiffs
  @dialyzer_warn_opts ~w(
      error_handling
      race_conditions
      unknown
      unmatched_returns
      )a
  defp dialyzer do
    [
      plt_add_apps: [:ex_unit],
      flags: [
        "-Wunmatched_returns" | @dialyzer_warn_opts
      ],
      ignore_warnings: ".dialyzer_ignore.exs",
      list_unused_filters: true
    ]
  end

  defp preferred_cli_env do
    [
      all_tests: :test,
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test
    ]
  end

  defp releases do
    [
      notris: [
        include_erts: true,
        include_executables_for: [:unix],
        applications: [
          notris: :permanent,
          notris_web: :permanent,
          runtime_tools: :permanent
        ]
      ]
    ]
  end
end

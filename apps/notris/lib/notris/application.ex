defmodule Notris.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      # Notris.Worker
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Notris.Supervisor)
  end
end

defmodule Ui.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    children = [
      # Start your own worker by calling: Ui.Worker.start_link(arg1, arg2, arg3)
      # worker(Ui.Worker, [arg1, arg2, arg3]),
      UiWeb.Endpoint,
      # Starts a worker by calling: Ui.Worker.start_link(arg)
      # {Ui.Worker, arg},

      # Required for Absinthe Subscriptions
      supervisor(Absinthe.Subscription, [UiWeb.Endpoint])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ui.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

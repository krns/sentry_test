defmodule SentryTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SentryTestWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:sentry_test, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SentryTest.PubSub},
      # Start a worker by calling: SentryTest.Worker.start_link(arg)
      # {SentryTest.Worker, arg},
      # Start to serve requests, typically the last entry
      SentryTestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SentryTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SentryTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

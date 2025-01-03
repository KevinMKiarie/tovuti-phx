defmodule Tovuti.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TovutiWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:tovuti, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tovuti.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Tovuti.Finch},
      # Start a worker by calling: Tovuti.Worker.start_link(arg)
      # {Tovuti.Worker, arg},
      # Start to serve requests, typically the last entry
      TovutiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tovuti.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TovutiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

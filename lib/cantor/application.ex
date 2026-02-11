defmodule Cantor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CantorWeb.Telemetry,
      Cantor.Repo,
      {AshAuthentication.Supervisor, otp_app: :cantor},
      {DNSCluster, query: Application.get_env(:cantor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cantor.PubSub},
      # Start a worker by calling: Cantor.Worker.start_link(arg)
      # {Cantor.Worker, arg},
      # Start to serve requests, typically the last entry
      CantorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cantor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CantorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule TodomvcBackendElixir do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(TodomvcBackendElixir.Repo, []),
      Plug.Adapters.Cowboy.child_spec(
        :http, TodomvcBackendElixir.Router, [], [port: 4001])
    ]

    Supervisor.start_link(children, [
      strategy: :one_for_one,
      name: TodomvcBackendElixir.Supervisor
    ])
  end
end

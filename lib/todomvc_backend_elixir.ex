defmodule TodomvcBackendElixir do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    IO.puts :stderr, "args is #{inspect(System.argv)}"
    {options, remaining_args, invalid_options} = OptionParser.parse(System.argv,
      switches: [port: :integer])
    if remaining_args != [] or invalid_options != [] do
      raise "Couldn't understand command-line args: #{inspect(System.argv)}"
    end
    port = options[:port]
    if port == nil do
      raise "Missing --port option"
    end
    IO.puts :stderr, "Running web server on port #{port}..."

    Supervisor.start_link([
      worker(TodomvcBackendElixir.Repo, []),
      Plug.Adapters.Cowboy.child_spec(
        :http, TodomvcBackendElixir.Router, [], [port: port])
    ], [
      strategy: :one_for_one,
      name: TodomvcBackendElixir.Supervisor
    ])
  end

end

defmodule TodomvcBackendElixir do
  use Application

  defmodule Options do
    defstruct []

    def parse_argv do
      {parsed, remaining, invalid} = OptionParser.parse(System.argv, switches: [
        port: :integer,
      ])
      if remaining != [] or invalid != [] do
        raise "Couldn't understand command-line args: #{inspect(System.argv)}"
      end

      {:done, options} = Enumerable.reduce parsed, {:cont, %Options{}},
        fn({field, value}, accum) -> {:cont, Map.put(accum, field, value)} end

      if options.port == nil do raise "Missing --port option" end

      options
    end
  end

  def start(_type, _args) do
    options = Options.parse_argv

    IO.puts :stderr, "Running web server on port #{options.port}..."
    Supervisor.start_link([
      Supervisor.Spec.worker(TodomvcBackendElixir.Repo, []),
      Plug.Adapters.Cowboy.child_spec(
        :http, TodomvcBackendElixir.Router, [], [port: options.port])
    ], [strategy: :one_for_one, name: TodomvcBackendElixir.Supervisor])
  end

end

defmodule TodomvcBackendElixir.Todo do
  use Ecto.Schema

  schema "todos" do
    field :title, :string
  end
end


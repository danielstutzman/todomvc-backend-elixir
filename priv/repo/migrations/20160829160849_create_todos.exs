defmodule TodomvcBackendElixir.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
    end
  end
end

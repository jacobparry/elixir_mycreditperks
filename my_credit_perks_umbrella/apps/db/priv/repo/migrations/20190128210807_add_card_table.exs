defmodule Db.Repo.Migrations.AddCardTable do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add(:name, :string)
      timestamps()
    end
  end
end

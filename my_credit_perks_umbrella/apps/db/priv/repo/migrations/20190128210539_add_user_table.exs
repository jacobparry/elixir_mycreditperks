defmodule Db.Repo.Migrations.AddUserTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string, size: 50)
      add(:password, :string, size: 100)
      add(:email, :string, size: 50)
      add(:age, :integer)

      timestamps()
    end
  end
end

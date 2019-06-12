defmodule Db.Repo.Migrations.AddSecurityFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:new_password, :string)
      add(:role, :string)
    end
  end
end

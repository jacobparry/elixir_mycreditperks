defmodule Db.Repo.Migrations.AddPerkTable do
  use Ecto.Migration

  def change do
    create table(:perks) do
      add(:type, :string)
      add(:description, :string)
      add(:card_id, references(:cards, on_delete: :nothing))

      timestamps()
    end
  end
end

defmodule Db.Repo.Migrations.AddUserCardsTable do
  use Ecto.Migration

  def change do
    create table(:user_cards) do
      add(:user_id, references(:users, on_delete: :nothing))
      add(:card_id, references(:cards, on_delete: :nothing))

      timestamps()
    end
  end
end

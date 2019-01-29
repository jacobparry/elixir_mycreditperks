defmodule Db.Models.UserCard do
  use Ecto.Schema

  import Ecto.Changeset

  schema "user_cards" do
    ###### 2.2-ecto-models-user-cards
    belongs_to(:user, Db.Models.User)
    belongs_to(:card, Db.Models.Card)
    timestamps()
    ###################

    @required_fields [
      :user_id,
      :card_id
    ]
    @optional_fields []

    def changeset(card, params \\ %{}) do
      card
      |> cast(params, @required_fields ++ @optional_fields)
      |> validate_required(@required_fields)
    end
  end
end

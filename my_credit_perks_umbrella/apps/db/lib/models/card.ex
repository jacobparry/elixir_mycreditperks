defmodule Db.Models.Card do
  use Ecto.Schema

  import Ecto.Changeset

  schema "cards" do
    ###### 2.1-ecto-models-card
    field(:name)
    timestamps()
    ###################

    ###### 2.3-ecto-models-perks
    has_many(:perks, Db.Models.Perk)
    ###################

    @required_fields [:name]
    @optional_fields []

    def changeset(card, params \\ %{}) do
      card
      |> cast(params, @required_fields ++ @optional_fields)
      |> validate_required(@required_fields)
    end
  end
end

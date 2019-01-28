defmodule Db.Models.Perk do
  use Ecto.Schema

  import Ecto.Changeset

  schema "perks" do
    ###### 2.3-ecto-models-perks
    field(:type, :string)
    field(:description, :string)
    timestamps()

    belongs_to(:card, Db.Models.Card)
    ###################

    @required_fields [
      :type,
      :description
    ]
    @optional_fields []

    def changeset(card, params \\ %{}) do
      card
      |> cast(params, @required_fields ++ @optional_fields)
      |> validate_required(@required_fields)
    end
  end
end

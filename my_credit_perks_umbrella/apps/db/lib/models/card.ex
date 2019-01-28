defmodule Db.Models.Card do
  use Ecto.Schema

  import Ecto.Changeset

  schema "cards" do
    ###### 2.1-ecto-models-card
    field(:name)
    belongs_to(:user, Db.Models.User)
    timestamps()
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

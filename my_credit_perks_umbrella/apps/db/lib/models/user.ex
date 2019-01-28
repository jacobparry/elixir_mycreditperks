defmodule Db.Models.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    ###### 2.0-ecto-models-user
    field(:username, :string)
    field(:password, :string)
    field(:email, :string)
    field(:age, :integer)
    timestamps()
    ###################

    ###### 2.1-ecto-models-card
    has_many(:cards, Db.Models.Card)
    ###################
  end

  @required_fields [
    :username,
    :password,
    :email
  ]
  @optional_fields [:age]

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

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
    field(:new_password, Comeonin.Ecto.Password)
    field(:role, :string)
  end

  @required_fields [
    :username,
    :password,
    :email,
    :new_password,
    :role
  ]
  @optional_fields [:age]

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username)
  end
end

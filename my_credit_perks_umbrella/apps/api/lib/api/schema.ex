defmodule Api.Schema do
  use Absinthe.Schema

  alias Db.Repo

  alias Db.Models.{
    User
  }

  """
  Keep in mind that your API and the underlying data representations
  do not need to be identical, or even have the same structure.
  One of the main values in modeling GraphQL types is that they
  can serve as an abstraction over whatever backing data store (or
  service) contains the associated data, transforming it before it’s
  transmitted to API users.
  """

  query do
    # The second arg defines the field type. This is by default a scalar value.
    # Absinthe has some defined build in: :integer, :float, :string, :boolean, :null, :id.
    # Can add custom scalar types
    field :health, :string,
      # Description is documation we can provide for and object type/field that will be available via introspection
      description: "Tests whether the GraphQL schema and endpoint are configured correctly.",

      # Name is required, but generated automatically if not manually specified.
      name: "healthy" do
      resolve(fn _, _, _ ->
        {:ok, "yup"}
      end)
    end

    field(:users, list_of(:user)) do
      resolve(fn _, _, _ ->
        {:ok, Repo.all(User)}
      end)
    end
  end

  object :user do
    field(:id, :id)
    field(:username, :string)
    field(:password, :string)
    field(:email, :string)
    field(:age, :integer)
  end
end

# IEX Commands to use
# Absinthe.Schema.lookup_type(Api.Schema, "Object") # Object is some object defined in the schema
# Absinthe.Schema.lookup_type(Api.Schema, "RootQueryType")

defmodule Api.Schema do
  use Absinthe.Schema
  use ApolloTracing

  alias Db.Repo

  alias Api.Resolvers.{
    CardResolver,
    UserResolver
  }

  alias Db.Models.{
    User,
    Card
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
      @desc "Matching a username"
      arg(:matching, :string)

      @desc "Orders by username"
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(&UserResolver.find_all_users/3)
    end

    field(:users_with_filters, list_of(:user)) do
      arg(:filter, :user_filter)
      resolve(&UserResolver.find_all_users_with_filters/3)
    end

    field(:cards, list_of(:card)) do
      resolve(&CardResolver.find_all_cards/3)
    end
  end

  object :user do
    field(:id, :id)
    field(:username, :string)
    field(:password, :string)
    field(:email, :string)
    field(:age, :integer)

    field(:user_cards, list_of(:card)) do
      resolve(&UserResolver.find_cards_for_user/3)
    end
  end

  object :card do
    field(:id, :id)
    field(:name, :string)

    field(:users_that_have_card, list_of(:user)) do
      resolve(&CardResolver.find_users_for_card/3)
    end
  end

  input_object :user_filter do
    @desc "Matching a username"
    field(:matching, :string)

    @desc "Orders by username"
    field(:order, type: :sort_order, default_value: :asc)
  end

  # By convention, enum values are passed in all uppercase letters.
  enum :sort_order do
    value(:asc)
    value(:desc)
  end
end

# IEX Commands to use
# Absinthe.Schema.lookup_type(Api.Schema, "Object") # Object is some object defined in the schema
# Absinthe.Schema.lookup_type(Api.Schema, "RootQueryType")

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

  import_types(Api.Schema.Queries.UserQueries)

  import_types(Api.Schema.ObjectTypes.UserTypes)
  import_types(Api.Schema.ObjectTypes.CardTypes)
  import_types(Api.Schema.ObjectTypes.DateTime)
  import_types(Api.Schema.ObjectTypes.SortOrder)

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

    import_fields(:user_queries)

    field(:users_with_filters, list_of(:user)) do
      arg(:filter, :user_filter)
      resolve(&UserResolver.find_all_users_with_filters/3)
    end

    field(:users_with_non_null_filters, list_of(:user)) do
      arg(:filter, non_null(:user_filter))
      resolve(&UserResolver.find_all_users_with_filters/3)
    end

    field(:users_with_non_null_inner_filters, list_of(:user)) do
      arg(:filter, non_null(:user_filter_non_null_field))
      resolve(&UserResolver.find_all_users_with_filters/3)
    end

    field(:cards, list_of(:card)) do
      resolve(&CardResolver.find_all_cards/3)
    end
  end
end

# IEX Commands to use
# Absinthe.Schema.lookup_type(Api.Schema, "Object") # Object is some object defined in the schema
# Absinthe.Schema.lookup_type(Api.Schema, "RootQueryType")

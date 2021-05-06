defmodule Api.Schema do
  use Absinthe.Schema

  # use ApolloTracing

  alias Api.Schema.Middleware
  alias Api.DataloaderSource

  @doc """
  Keep in mind that your API and the underlying data representations
  do not need to be identical, or even have the same structure.
  One of the main values in modeling GraphQL types is that they
  can serve as an abstraction over whatever backing data store (or
  service) contains the associated data, transforming it before it’s
  transmitted to API users.
  """

  import_types(Api.Schema.Queries.UserQueries)
  import_types(Api.Schema.Queries.CardQueries)

  import_types(Api.Schema.Mutations.UserMutations)
  import_types(Api.Schema.Mutations.CardMutations)

  import_types(Api.Schema.Subscriptions.UserSubscriptions)

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
    import_fields(:card_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:card_mutations)
  end

  subscription do
    import_fields(:user_subscriptions)
  end

  def middleware(middleware, field, object) do
    # IO.inspect(
    #   field_identifier: field.identifier,
    #   object_identifier: object.identifier
    # )

    middleware
    |> add(:debug, field, object)
    |> add(:changeset_errors, field, object)
    |> add(:apollo_tracing, field, object)
  end

  defp add(middleware, :apollo_tracing, _field, _object) do
    middleware ++ [ApolloTracing.Middleware.Tracing]
  end

  defp add(middleware, :changeset_errors, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  defp add(middleware, :debug, _field, _object) do
    if System.get_env("DEBUG") do
      [{Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
  end

  defp add(middleware, :changeset_errors, _field, _object) do
    middleware
  end

  def enable_debug_middleware do
    if Mix.env() == :dev do
      System.put_env("DEBUG", "true")
    end
  end

  def disable_debug_middleware do
    System.delete_env("DEBUG")
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(DataloaderSource, DataloaderSource.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end

# IEX Commands to use
# Absinthe.Schema.lookup_type(Api.Schema, "Object") # Object is some object defined in the schema
# Absinthe.Schema.lookup_type(Api.Schema, "RootQueryType")

defmodule UiWeb.Router do
  use UiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", UiWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/playground" do
    pipe_through(:api)

    # This creates the endpoint that an API client and our tests will use.
    forward("/api", Absinthe.Plug, schema: Api.Schema)

    # This enables the "in-browser" IDE for writing GraphQL things.
    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: Api.Schema,
      interface: :playground,
      pipeline: {ApolloTracing.Pipeline, :plug},

      # Required for Absinthe Subscriptions
      socket: UiWeb.UserSocket
    )
  end

  # Other scopes may use custom stacks.
  # scope "/api", UiWeb do
  #   pipe_through :api
  # end
end

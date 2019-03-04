defmodule Api.Resolvers.CardResolverTest do
  # Api.ApiCase allows us to build a connection and post it against an api endpoint
  # This allows us to test our GraphQL queries.
  # Once the mode is manual, tests can also be async
  use Api.ApiCase

  setup %{} do
    # https://hexdocs.pm/ecto/testing-with-ecto.html
    # This enables us to use a test database that is reset for every test.
    # Explicitly gets a connection before each test
    # This is used if we dont extend the ExUnit.Case module
    # Ecto.Adapters.SQL.Sandbox.checkout(Db.Repo)

    Db.Seeds.run()
    :ok
  end

  @query """
  {
    cards {
      id
      name
      usersThatHaveCard {
        id
      }
    }
  }
  """

  test "find_all_cards" do
    conn = build_conn()
    conn = get(conn, "/playground/api", query: @query)
    response = json_response(conn, 200)
    users = response["data"]["cards"]
    assert length(users) > 0
  end

  test "find_users_for_card/3" do
    conn = build_conn()
    conn = get(conn, "/playground/api", query: @query)
    response = json_response(conn, 200)
    returned_cards = response["data"]["cards"]

    Enum.any?(returned_cards, fn returned_card ->
      assert length(returned_card["usersThatHaveCard"]) > 0
    end)
  end
end

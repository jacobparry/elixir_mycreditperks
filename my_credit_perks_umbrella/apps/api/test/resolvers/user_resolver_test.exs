defmodule Api.Resolvers.UserResolverTest do
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
    users {
      id
      username
      email
      password
      userCards {
        id
        name
      }
    }
  }
  """

  test "find_all_users" do
    conn = build_conn()
    conn = get(conn, "/playground/api", query: @query)
    response = json_response(conn, 200)
    users = response["data"]["users"]
    assert length(users) > 0
  end

  test "find_cards_for_user/3" do
    conn = build_conn()
    conn = get(conn, "/playground/api", query: @query)
    response = json_response(conn, 200)
    returned_users = response["data"]["users"]

    Enum.any?(returned_users, fn returned_user ->
      assert length(returned_user["userCards"]) > 0
    end)
  end
end

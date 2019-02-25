defmodule Api.Resolvers.UserResolverTest do
  # use Api.ApiCase

  # UiWeb.ConnCase allows us to build a connection and post it against an api endpoint
  # This allows us to test our GraphQL queries
  use UiWeb.ConnCase, async: true

  @query """
  {
    users {
      id
    }
  }
  """

  describe "query" do
    test "users" do
      conn = build_conn()
      conn = get(conn, "/playground/api", query: @query)

      response = json_response(conn, 200)
      assert response == %{"data" => %{"users" => []}}
    end
  end
end

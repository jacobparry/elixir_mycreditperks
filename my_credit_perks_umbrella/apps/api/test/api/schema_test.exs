defmodule Api.SchemaTest do
  use ExUnit.Case

  # UiWeb.ConnCase allows us to build a connection and post it against an api endpoint
  # This allows us to test our GraphQL queries
  use UiWeb.ConnCase, async: true

  @query """
  {
    health
  }
  """

  describe "query" do
    test "health" do
      conn = build_conn()
      conn = get(conn, "/playground/api", query: @query)

      response = json_response(conn, 200)
      assert response == %{"data" => %{"health" => "up"}}
    end
  end
end

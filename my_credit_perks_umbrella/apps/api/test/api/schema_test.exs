defmodule Api.SchemaTest do
  use ExUnit.Case
  use UiWeb.ConnCase, async: true

  @query """
  {
    health
  }
  """

  describe "query" do
    test "health" do
      conn = build_conn()
      conn = get(conn, "/playground/graphiql", query: @query)

      response = json_response(conn, 200)
      assert response == %{"data" => %{"health" => "up"}}
    end
  end
end

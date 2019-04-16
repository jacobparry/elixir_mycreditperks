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

  @query_matching """
  {
    users (matching: "1") {
      username
    }
  }
  """
  test "users field returns users filtered by username" do
    conn = build_conn()
    conn = get(conn, "/playground/api", query: @query_matching)
    response = json_response(conn, 200)
    returned_users = response["data"]["users"]
    user = hd(returned_users)
    assert length(returned_users) == 1
    assert user == %{"username" => "test_1"}

    assert json_response(conn, 200) == %{
             "data" => %{
               "users" => [
                 %{"username" => "test_1"}
               ]
             }
           }
  end

  @query_matching_bad_value """
  {
    users (matching: 123) {
      username
    }
  }
  """
  test "users field returns errors when using a bad value" do
    conn = build_conn()
    conn = get(conn, "/playground/api", query: @query_matching_bad_value)
    response = json_response(conn, 200)
    assert %{"errors" => [%{"message" => message}]} = json_response(conn, 200)
    assert message == "Argument \"matching\" has invalid value 123."
  end

  @query_matching_variables """
  query ($term: String) {
    users (matching: $term) {
      username
    }
  }
  """
  @variables %{"term" => "1"}
  test "users field filtering with graphql variables" do
    conn = build_conn()
    conn = get(conn, "/playground/api", query: @query_matching_variables, variables: @variables)
    response = json_response(conn, 200)
    returned_users = response["data"]["users"]
    user = hd(returned_users)
    assert length(returned_users) == 1
    assert user == %{"username" => "test_1"}

    assert json_response(conn, 200) == %{
             "data" => %{
               "users" => [
                 %{"username" => "test_1"}
               ]
             }
           }
  end

  test "user ordering using sort_order enum asc by default" do
    query = """
    {
      users {
        username
      }
    }
    """

    conn = build_conn()
    conn = get(conn, "/playground/api", query: query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "users" => [
                 %{"username" => "test_1"},
                 %{"username" => "test_2"},
                 %{"username" => "test_3"}
               ]
             }
           }
  end

  test "user ordering using sort_order enum desc" do
    # By convention, enum values are passed in all uppercase letters.
    query = """
    {
      users (order: DESC) {
        username
      }
    }
    """

    conn = build_conn()
    conn = get(conn, "/playground/api", query: query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "users" => [
                 %{"username" => "test_3"},
                 %{"username" => "test_2"},
                 %{"username" => "test_1"}
               ]
             }
           }
  end

  test "user ordering using sort_order enum desc with variable" do
    # By convention, enum values are passed in all uppercase letters.
    query = """
    query ($order: SortOrder!) {
      users (order: $order) {
        username
      }
    }
    """

    variables = %{
      order: "DESC"
    }

    conn = build_conn()
    conn = get(conn, "/playground/api", query: query, variables: variables)

    assert json_response(conn, 200) == %{
             "data" => %{
               "users" => [
                 %{"username" => "test_3"},
                 %{"username" => "test_2"},
                 %{"username" => "test_1"}
               ]
             }
           }
  end

  test "user filter input object" do
    # By convention, enum values are passed in all uppercase letters.
    query = """
    query {
      usersWithFilters (filter: {matching: "1"}) {
        username
      }
    }
    """

    conn = build_conn()
    conn = get(conn, "/playground/api", query: query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "usersWithFilters" => [
                 %{"username" => "test_1"}
               ]
             }
           }
  end

  test "user filter input object with desc" do
    # By convention, enum values are passed in all uppercase letters.
    query = """
    query {
      usersWithFilters (filter: {order: DESC}) {
        username
      }
    }
    """

    conn = build_conn()
    conn = get(conn, "/playground/api", query: query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "usersWithFilters" => [
                 %{"username" => "test_3"},
                 %{"username" => "test_2"},
                 %{"username" => "test_1"}
               ]
             }
           }
  end

  test "user non null filters" do
    # By convention, enum values are passed in all uppercase letters.
    query = """
    query {
      usersWithNonNullFilters  {
        username
      }
    }
    """

    conn = build_conn()
    conn = get(conn, "/playground/api", query: query)

    assert json_response(conn, 200) == %{
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "In argument \"filter\": Expected type \"UserFilter!\", found null."
               }
             ]
           }
  end

  test "user non null inner filters" do
    # By convention, enum values are passed in all uppercase letters.
    query = """
    query {
      usersWithNonNullInnerFilters (filter: {}) {
        username
      }
    }
    """

    conn = build_conn()
    conn = get(conn, "/playground/api", query: query)

    assert json_response(conn, 200) == %{
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" =>
                   "Argument \"filter\" has invalid value {}.\nIn field \"matching\": Expected type \"String!\", found null."
               }
             ]
           }
  end

  describe "datetime scalar type" do
    # This is a bad test because it relys on when the seed data was inserted.
    test "filters by datetime" do
      query = """
      query ($filter: UserFilter) {
        usersWithFilters (filter: $filter) {
          username
        }
      }
      """

      variables = %{
        filter: %{
          added_before: "2019-04-21"
        }
      }

      conn = build_conn()
      conn = get(conn, "/playground/api", query: query, variables: variables)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "usersWithFilters" => [
                   %{"username" => "test_1"},
                   %{"username" => "test_2"},
                   %{"username" => "test_3"}
                 ]
               }
             }
    end

    # This is a bad test because it relys on when the seed data was inserted.
    test "scalar datetime throws bad input string error" do
      query = """
      query ($filter: UserFilter) {
        usersWithFilters (filter: $filter) {
          username
        }
      }
      """

      variables = %{
        filter: %{
          added_before: "not-a-date"
        }
      }

      conn = build_conn()
      conn = get(conn, "/playground/api", query: query, variables: variables)

      assert json_response(conn, 200) == %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 0, "line" => 2}],
                   "message" =>
                     "Argument \"filter\" has invalid value $filter.\nIn field \"added_before\": Expected type \"DateTime\", found \"not-a-date\"."
                 }
               ]
             }
    end
  end
end

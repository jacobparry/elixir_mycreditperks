defmodule Db.Models.UserTest do
  use ExUnit.Case
  alias Db.Models.User

  setup %{} do
    # https://hexdocs.pm/ecto/testing-with-ecto.html
    # This enables us to use a test database that is reset for every test.
    # Explicitly gets a connection before each test
    Ecto.Adapters.SQL.Sandbox.checkout(Db.Repo)

    Db.Seeds.run()

    :ok
  end

  describe "changeset/2" do
    test "returns a valid changeset" do
      params = %{
        username: "user_1",
        password: "password_1",
        email: "email_1",
        age: "21"
      }

      changeset = User.changeset(%User{}, params)
      assert changeset.valid?
    end

    test "a missing USERNAME returns an invalid changeset" do
      params = %{
        password: "password_1",
        email: "email_1",
        age: "21"
      }

      changeset = User.changeset(%User{}, params)
      refute changeset.valid?
    end

    test "a missing PASSWORD returns an invalid changeset" do
      params = %{
        username: "user_1",
        email: "email_1",
        age: "21"
      }

      changeset = User.changeset(%User{}, params)
      refute changeset.valid?
    end

    test "a missing EMAIL returns an invalid changeset" do
      params = %{
        username: "user_1",
        password: "password_1",
        age: "21"
      }

      changeset = User.changeset(%User{}, params)
      refute changeset.valid?
    end

    test "a missing AGE still returns a valid changeset" do
      params = %{
        username: "user_1",
        password: "password_1",
        email: "email_1"
      }

      changeset = User.changeset(%User{}, params)
      assert changeset.valid?
    end
  end
end

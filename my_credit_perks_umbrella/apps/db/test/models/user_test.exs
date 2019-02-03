defmodule Db.Models.UserTest do
  use ExUnit.Case
  alias Db.Models.User

  describe "changeset/2" do
    test "returns a valid changeset" do
      params = %{
        username: "user_01",
        password: "password_01",
        email: "email_01",
        age: "21"
      }

      changeset = User.changeset(%User{}, params)

      assert changeset.valid?
    end

    test "a missing USERNAME returns an invalid changeset" do
      params = %{
        password: "password_01",
        email: "email_01",
        age: "21"
      }

      changeset = User.changeset(%User{}, params)

      refute changeset.valid?
    end

    test "a missing PASSWORD returns an invalid changeset" do
      params = %{
        username: "user_01",
        email: "email_01",
        age: "21"
      }

      changeset = User.changeset(%User{}, params)
      refute changeset.valid?
    end

    test "a missing EMAIL returns an invalid changeset" do
      params = %{
        username: "user_01",
        password: "password_01",
        age: "21"
      }

      changeset = User.changeset(%User{}, params)
      refute changeset.valid?
    end

    test "a missing AGE still returns a valid changeset" do
      params = %{
        username: "user_01",
        password: "password_01",
        email: "email_01"
      }

      changeset = User.changeset(%User{}, params)
      assert changeset.valid?
    end
  end
end

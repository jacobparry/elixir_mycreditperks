defmodule CreditPerks.Contexts.UsersContextTest do
  use CreditPerks.Case
  alias CreditPerks.Contexts.UsersContext

  alias Db.Models.User

  describe "users" do
    setup %{} do
      params = %{
        username: "test_01",
        password: "password_01",
        email: "email_01@test.com",
        age: 100,
        new_password: "new_password_01",
        role: "ADMIN"
      }

      {:ok, user} =
        %User{}
        |> User.changeset(params)
        |> UsersContext.create()

      {:ok, %{user: user}}
    end

    test "get_all/0 returns all users", %{user: user} do
      assert UsersContext.get_all() == [user]
    end

    test "get_by_id/1 returns the user with given id", %{user: user} do
      assert UsersContext.get_by_id(user.id) == user
    end

    test "any/0 returns true if there are users in the database" do
      assert UsersContext.any?()
    end

    test "any/0 returns false if there are no users in the database", %{user: user} do
      UsersContext.delete(user)
      refute UsersContext.any?()
    end

    test "create/1 with valid data creates a user" do
      params = %{
        username: "test_04",
        password: "password_04",
        email: "email_01@test.com",
        age: 100,
        new_password: "new_password_01",
        role: "ADMIN"
      }

      {:ok, user} =
        %User{}
        |> User.changeset(params)
        |> UsersContext.create()

      assert %User{} = user
      assert user.username == params[:username]
    end

    test "create/1 fails if the user is not unique" do
      params = %{
        username: "test_01",
        password: "password_01",
        email: "email_01@test.com",
        age: 100,
        new_password: "new_password_01",
        role: "ADMIN"
      }

      {:error, %Ecto.Changeset{} = changeset} =
        %User{}
        |> User.changeset(params)
        |> UsersContext.create()

      assert [username: {"has already been taken", _}] = changeset.errors
    end

    test "create/1 with bad data does not create a user" do
      # Missing username
      params = %{
        password: "password_01",
        email: "email_01@test.com",
        age: 100
      }

      {:error, %Ecto.Changeset{} = changeset} =
        %User{}
        |> User.changeset(params)
        |> UsersContext.create()

      refute changeset.valid?
    end

    test "update/2 with good data updates a user", %{user: user} do
      params = %{
        username: "updated_username"
      }

      {:ok, updated_user} =
        user
        |> User.changeset(params)
        |> UsersContext.update()

      assert user.id == updated_user.id
      assert updated_user.username == params[:username]
    end

    test "update/2 with bad data does not update a user", %{user: user} do
      params = %{
        username: nil
      }

      {:error, %Ecto.Changeset{} = changeset} =
        user
        |> User.changeset(params)
        |> UsersContext.update()

      refute changeset.valid?
    end

    test "delete/1 deletes a user", %{user: user} do
      UsersContext.delete(user)
      refute UsersContext.any?()
    end
  end
end

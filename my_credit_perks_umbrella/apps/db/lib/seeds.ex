defmodule Db.Seeds do
  alias Db.Models.{
    Card,
    Perk,
    User,
    UserCard
  }

  alias Db.Repo

  def run() do
    seed_users()
    seed_cards()
  end

  defp seed_users() do
    users = [
      User.changeset(%User{}, %{
        username: "test_1",
        password: "very_secure_password",
        email: "test_1@test.com"
      }),
      User.changeset(%User{}, %{
        username: "test_2",
        password: "very_secure_password",
        email: "test_2@test.com"
      }),
      User.changeset(%User{}, %{
        username: "test_3",
        password: "very_secure_password",
        email: "test_3@test.com"
      })
    ]

    inserted_users =
      Enum.map(users, fn user ->
        Repo.insert(user)
      end)
  end

  defp seed_cards() do
    cards = [
      Card.changeset(%Card{}, %{
        name: "Chase Sapphire Preferred"
      }),
      Card.changeset(%Card{}, %{
        name: "Citi Costco Visa"
      }),
      Card.changeset(%Card{}, %{
        name: "American Express Gold"
      })
    ]

    inserted_cards =
      Enum.map(cards, fn card ->
        Repo.insert(card)
      end)
  end
end

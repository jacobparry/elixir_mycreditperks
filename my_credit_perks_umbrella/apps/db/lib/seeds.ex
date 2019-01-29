defmodule Db.Seeds do
  alias Db.Models.{
    Card,
    Perk,
    User,
    UserCard
  }

  alias Db.Repo

  def seed() do
    seed_users()
    seed_cards()
  end

  defp seed_users() do
    users = [
      User.changeset(%User{}, %{
        username: "test1",
        password: "1234",
        email: "test1@test.com"
      }),
      User.changeset(%User{}, %{
        username: "test2",
        password: "1234",
        email: "test2@test.com"
      }),
      User.changeset(%User{}, %{
        username: "test3",
        password: "1234",
        email: "test3@test.com"
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

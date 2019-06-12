defmodule Db.Seeds do
  alias Db.Models.{
    Card,
    Perk,
    User,
    UserCard
  }

  alias Db.Repo

  def run() do
    users = seed_users()
    cards = seed_cards()
    seed_user_cards(users, cards)
  end

  defp seed_users() do
    users = [
      User.changeset(%User{}, %{
        username: "test_1",
        password: "very_secure_password",
        email: "test_1@test.com",
        age: 21,
        role: "ADMIN",
        new_password: "strong_password"
      }),
      User.changeset(%User{}, %{
        username: "test_2",
        password: "very_secure_password",
        email: "test_2@test.com",
        age: 16,
        role: "EMPLOYEE",
        new_password: "strong_password"
      }),
      User.changeset(%User{}, %{
        username: "test_3",
        password: "very_secure_password",
        email: "test_3@test.com",
        age: 33,
        role: "EMPLOYEE",
        new_password: "strong_password"
      })
    ]

    inserted_users =
      Enum.map(users, fn user ->
        Repo.insert(user)
        |> IO.inspect()
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

  defp seed_user_cards(users, cards) do
    Enum.map(users, fn {:ok, user} ->
      Enum.map(cards, fn {:ok, card} ->
        UserCard.changeset(%UserCard{}, %{
          user_id: user.id,
          card_id: card.id
        })
        |> Repo.insert()
      end)
    end)
  end
end

defmodule Api.Resolvers.CardResolver do
  import Ecto.Query

  alias Db.Models.{
    Card,
    UserCard
  }

  alias Db.Repo

  def find_all_cards(_, _, _) do
    {:ok, Repo.all(Card)}
  end

  def find_users_for_card(parent, _, _) do
    query =
      from(uc in UserCard,
        join: u in assoc(uc, :user),
        where: uc.card_id == ^parent.id,
        select: u
      )

    Repo.all(query)
    {:ok, Repo.all(query)}
  end
end

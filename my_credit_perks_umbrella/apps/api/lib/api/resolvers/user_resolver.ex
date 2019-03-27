defmodule Api.Resolvers.UserResolver do
  import Ecto.Query

  alias Db.Models.{
    User,
    UserCard,
    Card
  }

  alias Db.Repo

  def find_all_users(_parent, %{order: order} = _params, _resolution) do
    IO.inspect("MATCHING")

    query =
      from(u in User,
        order_by: [^order, u.username]
      )

    {:ok, Repo.all(query)}
  end

  def find_all_users(_parent, %{matching: matching} = _params, _resolution) do
    IO.inspect("MATCHING")

    query =
      from(u in User,
        where: ilike(u.username, ^"%#{matching}%")
      )

    {:ok, Repo.all(query)}
  end

  def find_all_users(_parent, params, _resolution) do
    IO.inspect("EVERYTHING")

    {:ok, Repo.all(User)}
  end

  def find_cards_for_user(parent, _params, _resolution) do
    query =
      from(uc in UserCard,
        join: c in assoc(uc, :card),
        where: uc.user_id == ^parent.id,
        select: c
      )

    {:ok, Repo.all(query)}
  end
end

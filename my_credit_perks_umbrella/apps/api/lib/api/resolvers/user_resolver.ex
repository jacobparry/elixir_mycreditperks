defmodule Api.Resolvers.UserResolver do
  import Ecto.Query

  alias Db.Models.{
    User,
    UserCard,
    Card
  }

  alias Db.Repo

  def find_all_users(_parent, %{matching: matching} = _params, _resolution) do
    IO.inspect("MATCHING")

    query =
      from(u in User,
        where: ilike(u.username, ^"%#{matching}%")
      )

    Repo.all(query)
    |> length()
    |> IO.inspect()

    {:ok, Repo.all(User)}
  end

  def find_all_users(_parent, params, _resolution) do
    IO.inspect("EVERYTHING")

    Repo.all(User)
    |> length()
    |> IO.inspect()

    {:ok, Repo.all(User)}
  end

  def find_cards_for_user(parent, _params, _resolution) do
    query =
      from(uc in UserCard,
        join: c in assoc(uc, :card),
        where: uc.user_id == ^parent.id,
        select: c
      )

    Repo.all(query)
    |> length()
    |> IO.inspect()

    {:ok, Repo.all(query)}
  end
end

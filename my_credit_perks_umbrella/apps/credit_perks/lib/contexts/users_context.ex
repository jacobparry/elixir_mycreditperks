defmodule CreditPerks.Contexts.UsersContext do
  import Ecto.Query
  alias Db.Repo

  alias Db.Models.{
    User,
    UserCard
  }

  def get_all do
    Repo.all(from(User))
  end

  def get_by_id(id) do
    query =
      from(u in User,
        where: u.id == ^id
      )

    Repo.one(query)
  end

  def any? do
    count =
      Repo.one(
        from(u in User,
          select: count(u.id)
        )
      )

    count != 0
  end

  def create(user) do
    Repo.insert(user)
  end

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def update(user) do
    Repo.update(user)
  end

  def delete(user) do
    Repo.delete(user)
  end

  def find_all_users(%{matching: matching} = _params) do
    query =
      from(u in User,
        where: ilike(u.username, ^"%#{matching}%")
      )

    {:ok, Repo.all(query)}
  end

  def find_all_users(%{order: order} = _params) do
    query =
      from(u in User,
        order_by: {^order, u.username}
      )

    {:ok, Repo.all(query)}
  end

  def find_all_users(_params) do
    {:ok, Repo.all(User)}
  end

  def find_all_users_with_filters(%{filter: filters} = _params) do
    query =
      from(u in User)
      |> matching_filter(filters[:matching])
      |> order_filter(filters[:order])

    {:ok, Repo.all(query)}
  end

  def matching_filter(query, nil), do: query

  def matching_filter(query, matching_string) do
    from(u in query,
      where: ilike(u.username, ^"%#{matching_string}%")
    )
  end

  def order_filter(query, nil), do: query

  def order_filter(query, order) do
    from(u in query,
      order_by: {^order, u.username}
    )
  end

  def find_cards_for_user(%User{} = user) do
    query =
      from(uc in UserCard,
        join: c in assoc(uc, :card),
        where: uc.user_id == ^user.id,
        select: c
      )

    {:ok, Repo.all(query)}
  end
end

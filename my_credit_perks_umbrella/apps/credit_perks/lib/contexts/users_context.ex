defmodule CreditPerks.Contexts.UsersContext do
  import Ecto.Query

  alias Comeonin.Ecto.Password
  alias Db.Repo

  alias Db.Models.{
    User,
    UserCard
  }

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def authenticate_user(username, password) do
    user = get_user_by_username(username)

    with %{new_password: pass_to_validate} <- user,
         true <- Password.valid?(password, pass_to_validate) do
      {:ok, user}
    else
      _ ->
        {:error, "Could not authenticate user"}
    end
  end

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

  def find_user_by_id(id) do
    case get_by_id(id) do
      %User{} = user ->
        {:ok, user}

      _ ->
        {:error, "Could not find user"}
    end
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

  def update_user(%{id: id} = params) do
    {:ok, user} = find_user_by_id(id)

    user
    |> User.changeset(params)
    |> Repo.update()
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

  def get_cards_by_user_id(%{card_name_contains: name_str}, user_ids) do
    Process.sleep(1000)
    IO.inspect("************* Finding User Cards Batch filters")
    IO.inspect("************* #{Timex.now()}")

    query =
      from(uc in UserCard,
        join: c in assoc(uc, :card),
        where: uc.user_id in ^user_ids,
        where: ilike(c.name, ^"%#{name_str}%"),
        # where: not ilike(c.company_name_on_card, ^"%defunct%"),

        select: {uc.user_id, c}
      )

    query
    |> Repo.all()
    # |> IO.inspect()
    |> Map.new()
  end

  def get_cards_by_user_id(_filter_params, user_ids) do
    Process.sleep(1000)
    IO.inspect("************* Finding User Cards Batch")
    IO.inspect("************* #{Timex.now()}")

    query =
      from(uc in UserCard,
        join: c in assoc(uc, :card),
        where: uc.user_id in ^user_ids,
        select: {uc.user_id, c}
      )

    query
    |> Repo.all()
  end
end

defmodule Api.Resolvers.UserResolver do
  import Ecto.Query

  alias CreditPerks.Contexts.UsersContext

  alias Db.Models.{
    User,
    UserCard
  }

  alias Db.Repo

  def find_all_users(_parent, %{matching: matching} = _params, _resolution) do
    query =
      from(u in User,
        where: ilike(u.username, ^"%#{matching}%")
      )

    {:ok, Repo.all(query)}
  end

  def find_all_users(_parent, %{order: order} = _params, _resolution) do
    query =
      from(u in User,
        order_by: {^order, u.username}
      )

    {:ok, Repo.all(query)}
  end

  def find_all_users(_parent, _params, _resolution) do
    {:ok, Repo.all(User)}
  end

  def find_all_users_with_filters(_parent, %{filter: filters} = _params, _resolution) do
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

  def find_cards_for_user(parent, _params, _resolution) do
    query =
      from(uc in UserCard,
        join: c in assoc(uc, :card),
        where: uc.user_id == ^parent.id,
        select: c
      )

    {:ok, Repo.all(query)}
  end

  def create_user(_parent, %{input: params} = _params, _resolution) do
    case UsersContext.create_user(params) do
      {:ok, _user} = result ->
        result

      {:error, _} ->
        {:error, "Could not create user"}
    end
  end

  def create_user_better_errors(_parent, %{input: params} = _params, _resolution) do
    case UsersContext.create_user(params) do
      {:ok, _user} = result ->
        result

      {:error, changeset} ->
        {:error, message: "Could not create user", details: changeset_error_details(changeset)}
    end
  end

  def create_user_best_errors(_parent, %{input: params} = _params, _resolution) do
    case UsersContext.create_user(params) do
      {:ok, user} = _result ->
        IO.inspect("BANG BANG")
        {:ok, %{user: user}}

      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  defp changeset_error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end

  defp transform_errors(%Ecto.Changeset{} = changeset) do
    changeset
    |> IO.inspect()
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn {key, value} ->
      %{key: key, message: value}
    end)
  end

  @spec format_error(Ecto.Changeset.error()) :: String.t()
  defp format_error({msg, opts}) do
    Enum.reduce(
      opts,
      msg,
      fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end
    )
  end
end

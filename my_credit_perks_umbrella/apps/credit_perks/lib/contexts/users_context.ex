defmodule CreditPerks.Contexts.UsersContext do
  import Ecto.Query
  alias Db.Repo

  alias Db.Models.{
    User
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

  def update(user) do
    Repo.update(user)
  end

  def delete(user) do
    Repo.delete(user)
  end
end

defmodule Db.RepoCase do
  @moduledoc """
  https://hexdocs.pm/ecto/testing-with-ecto.html

  This module extends the ExUnit template

  You need to establish the database connection ahead of your tests.
  You can enable it either for all of your test cases by extending the ExUnit template
  or by setting it up individually for each test.
  This implementation here extends the ExUnit template.

  If the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Db.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Db.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Db.Repo, {:shared, self()})
    end

    :ok
  end
end

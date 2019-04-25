ExUnit.start()

# https://hexdocs.pm/ecto/testing-with-ecto.html
# This allows us to use a test db that is reset between tests.
# Set the pool mode to manual for explicit checkouts
Ecto.Adapters.SQL.Sandbox.mode(Db.Repo, :manual)

defmodule Api.DataloaderSource do
  def data() do
    Dataloader.Ecto.new(Db.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end

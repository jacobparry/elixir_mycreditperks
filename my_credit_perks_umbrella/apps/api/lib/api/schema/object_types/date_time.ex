defmodule Api.Schema.ObjectTypes.DateTime do
  use Absinthe.Schema.Notation

  scalar :date_time do
    # Parse converts a value coming from the user into an Elixir term or returns :error
    parse(fn input ->
      with {:ok, date} <- Date.from_iso8601(input.value),
           datetime <- Timex.to_datetime(date) do
        {:ok, datetime}
      else
        _ -> :error
      end
    end)

    # Serialize converts a Elixir term back into a value that can be returned via JSON
    serialize(fn datetime ->
      datetime
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_iso8601()
    end)
  end
end

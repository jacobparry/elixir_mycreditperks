defmodule Api.Schema.Middleware.Authorize do
  @behavior Absinthe.Middleware

  def call(resolution, role) do
    with %{current_user: current_user} <- resolution.context,
         true <- correct_role?(current_user, role) do
      resolution
    else
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "middleware unathorized"})
    end
  end

  defp correct_role?(%{}, :any) do
    true
  end

  defp correct_role?(%{role: role}, role) do
    true
  end

  defp correct_role?(_, _) do
    false
  end
end

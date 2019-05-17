defmodule Api.Resolvers.CardResolver do
  @moduledoc """
    Resolver that handles getting information regarding the Card Struct
  """

  alias CreditPerks.Contexts.CardsContext

  def find_all_cards(_, _, _) do
    case CardsContext.find_all_cards() do
      {:ok, _} = success ->
        success

      {:error, _} ->
        {:error, "Could not fetch all cards"}
    end
  end

  def find_users_for_card(parent, _, _) do
    case CardsContext.find_users_for_card(parent) do
      {:ok, _} = success ->
        success

      {:error, _} ->
        {:error, "Could not fetch users for card"}
    end
  end

  def create_card(_parent, %{input: params} = _params, _) do
    case CardsContext.create_card(params) do
      {:ok, _} = success ->
        success

      {:error, _} ->
        {:error, message: "Could not create card", details: changeset_error_details(changeset)}
    end
  end

  defp changeset_error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end

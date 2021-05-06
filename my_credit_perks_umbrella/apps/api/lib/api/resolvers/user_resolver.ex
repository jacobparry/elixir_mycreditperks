defmodule Api.Resolvers.UserResolver do
  @moduledoc """
  Resolver that handles getting information regarding the User Struct
  """
  import Absinthe.Resolution.Helpers, only: [async: 1, batch: 3]

  alias CreditPerks.Contexts.UsersContext

  def find_all_users(_parent, %{matching: _matching} = params, _resolution) do
    case UsersContext.find_all_users(params) do
      {:ok, _} = success ->
        success

      {:error, _} ->
        {:error, "Could not fetch all users"}
    end
  end

  def find_all_users(_parent, %{order: _order} = params, _resolution) do
    case UsersContext.find_all_users(params) do
      {:ok, _} = success ->
        success

      {:error, _} ->
        {:error, "Could not fetch all users"}
    end
  end

  def find_all_users(_parent, _params, _resolution) do
    case UsersContext.find_all_users(%{}) do
      {:ok, _} = success ->
        success

      {:error, _} ->
        {:error, "Could not fetch all users"}
    end
  end

  def find_all_users_with_filters(_parent, params, _resolution) do
    case UsersContext.find_all_users_with_filters(params) do
      {:ok, _} = success ->
        success

      {:error, _} ->
        {:error, "Could not fetch all users with filters"}
    end
  end

  def find_cards_for_user(parent, _params, _resolution) do
    Process.sleep(1000)
    IO.inspect("************* Finding User Cards")
    IO.inspect("************* #{Timex.now()}")

    case UsersContext.find_cards_for_user(parent) do
      {:ok, _} = success ->
        success

      {:error, _} ->
        {:error, "Could not cards for user"}
    end
  end

  def find_cards_for_user_async(parent, _params, _resolution) do
    async(fn ->
      Process.sleep(1000)
      IO.inspect("************* Finding User Cards Async")
      IO.inspect("************* #{Timex.now()}")

      case UsersContext.find_cards_for_user(parent) do
        {:ok, _} = success ->
          success

        {:error, _} ->
          {:error, "Could not cards for user"}
      end
    end)
  end

  def find_cards_for_user_batch(parent, _params, _resolution) do
    batch({UsersContext, :get_cards_by_user_id}, parent.id, fn cards ->
      card_list =
        cards
        |> Keyword.take([parent.id])
        |> IO.inspect()
        |> Enum.map(fn {user_id, card} ->
          card
        end)

      # c_list =
      #   Enum.map(cards, fn {id, card} = _object ->
      #     if id == parent.id do
      #       card
      #     else
      #       nil
      #     end
      #   end)

      # l =
      #   Enum.filter(c_list, fn c ->
      #     c != nil
      #   end)

      {:ok, card_list}
    end)
  end

  def find_cards_for_user_dataloader(parent, _params, %{context: %{loader: loader}}) do
    # loader
    # |> Dataloader.load_many(Api.DataloaderSource, Db.Models.UserCard, )
    # |> IO.inspect()

    case UsersContext.find_cards_for_user(parent) do
      {:ok, _} = success ->
        success

      {:error, _} ->
        {:error, "Could not cards for user"}
    end
  end

  def find_cards_for_user_batch_odds(parent, _params, _resolution) do
    batch(
      {UsersContext, :get_cards_by_user_id, %{card_name_contains: "Chase"}},
      parent.id,
      fn cards ->
        {:ok, Map.get(cards, parent.id)}
      end
    )
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
      {:ok, user} = result ->
        Absinthe.Subscription.publish(UiWeb.Endpoint, user, new_user: "*")
        result

      {:error, changeset} ->
        {:error, message: "Could not create user", details: changeset_error_details(changeset)}
    end
  end

  def create_user_restricted(
        _parent,
        %{input: params} = _params,
        %{context: context} = _resolution
      ) do
    case context do
      %{current_user: %{role: "ADMIN"}} ->
        case UsersContext.create_user(params) do
          {:ok, user} = result ->
            result

          {:error, changeset} ->
            {:error,
             message: "Could not create user", details: changeset_error_details(changeset)}
        end

      _ ->
        {:error, "Unauthorized"}
    end
  end

  def create_user_with_middleware(_parent, %{input: params} = _params, _resolution) do
    with {:ok, user} <- UsersContext.create_user(params) do
      {:ok, %{user: user}}
    end
  end

  def create_user_best_errors(_parent, %{input: params} = _params, _resolution) do
    case UsersContext.create_user(params) do
      {:ok, user} = _result ->
        {:ok, %{user: user}}

      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  def update_user(_parent, %{input: params} = _params, _resolution) do
    case UsersContext.update_user(params) do
      {:ok, user} = result ->
        Absinthe.Subscription.publish(UiWeb.Endpoint, user, update_user: user.password)
        result

      {:error, changeset} ->
        {:error, message: "Could not update user", details: changeset_error_details(changeset)}
    end
  end

  def update_user_trigger(_parent, %{input: params} = _params, _resolution) do
    case UsersContext.update_user(params) do
      {:ok, _user} = result ->
        result

      {:error, changeset} ->
        {:error, message: "Could not update user", details: changeset_error_details(changeset)}
    end
  end

  def login_user(_parent, %{input: %{username: username, password: password}} = args, _resolution) do
    case UsersContext.authenticate_user(username, password) do
      {:ok, user} ->
        token = UiWeb.Authentication.sign(%{id: user.id, role: user.role})
        {:ok, %{token: token, user: user}}

      error ->
        IO.inspect(error)
        {:error, "Incorrect credentials"}
    end
  end

  defp changeset_error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end

  defp transform_errors(%Ecto.Changeset{} = changeset) do
    changeset
    # |> IO.inspect()
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

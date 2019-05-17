defmodule Api.Schema.Subscriptions.UserSubscriptions do
  @moduledoc """
  Module for containing the schema fields for user subscriptions
  """

  use Absinthe.Schema.Notation

  object :user_subscriptions do
    field :new_user, :user do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
    end
  end
end

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

    field :update_user, :user do
      arg(:id, non_null(:id))

      # If whatever we are listening to contains "brady", then we get the subscription.
      config(fn args, _info ->
        {:ok, topic: "brady"}
      end)
    end

    field :update_user_trigger, :user do
      arg(:id, non_null(:id))

      config(fn args, _info ->
        {:ok, topic: args.id}
      end)

      # trigger/2 takes two params.
      # 1: a mutation name or list of names
      # 2: set of options for specifying topic functions
      trigger([:update_user_trigger],
        topic: fn
          user -> [user.id]
          _ -> []
        end
      )

      resolve(fn user, _, _ ->
        # IO.inspect(user)
        {:ok, user}
      end)
    end
  end
end

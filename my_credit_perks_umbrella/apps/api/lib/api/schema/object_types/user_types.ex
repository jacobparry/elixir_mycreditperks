defmodule Api.Schema.ObjectTypes.UserTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Api.Resolvers.UserResolver

  object :user do
    field(:id, :id)
    field(:username, :string)
    field(:password, :string)
    field(:new_password, :string)
    field(:email, :string)
    field(:age, :integer)
    field(:inserted_at, :string)
    field(:updated_at, :date_time)

    field(:user_cards, list_of(:card)) do
      resolve(&UserResolver.find_cards_for_user/3)
    end

    field(:user_cards_async, list_of(:card)) do
      resolve(&UserResolver.find_cards_for_user_async/3)
    end

    field(:user_cards_batch, list_of(:card)) do
      resolve(&UserResolver.find_cards_for_user_batch/3)
    end

    field(:user_cards_dataloader, list_of(:card)) do
      resolve(&UserResolver.find_cards_for_user_dataloader/3)
    end

    field(:user_cards_dataloader_broken, list_of(:card)) do
      resolve(dataloader(Api.DataloaderSource))
    end

    field(:user_cards_batch_filters, list_of(:card)) do
      resolve(&UserResolver.find_cards_for_user_batch_odds/3)
    end
  end

  interface :other_user do
    field(:username, :string)
    field(:role, :string)

    resolve_type(fn
      %{role: "ADMIN"}, _ -> :admin
      %{role: "EMPLOYEE"}, _ -> :employee
    end)
  end

  object :admin do
    interface(:other_user)
    field(:username, :string)
    field(:role, :string)
    field(:age, :integer)

    field(:user_cards, list_of(:card)) do
      resolve(&UserResolver.find_cards_for_user/3)
    end
  end

  object :employee do
    interface(:other_user)

    field(:username, :string)
    field(:role, :string)
    field(:inserted_at, :string)
    field(:updated_at, :date_time)
  end

  object :session do
    field(:token, :string)
    field(:user, :user)
  end

  enum :role do
    value(:admin)
    value(:employee)
  end

  input_object :login_input do
    field(:username, non_null(:string))
    field(:password, non_null(:string))
  end

  input_object :user_filter do
    @desc "Matching a username"
    field(:matching, :string)

    @desc "Orders by username"
    field(:order, type: :sort_order, default_value: :asc)

    @desc "Filter by added_before date"
    field(:added_before, :date_time)

    @desc "Filter by added_after date"
    field(:added_after, :date_time)
  end

  input_object :user_filter_non_null_field do
    @desc "Matching a username"
    field(:matching, non_null(:string))

    @desc "Orders by username"
    field(:order, type: :sort_order, default_value: :asc)
  end
end

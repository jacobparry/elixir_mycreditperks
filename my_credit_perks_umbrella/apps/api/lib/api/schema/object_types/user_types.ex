defmodule Api.Schema.ObjectTypes.UserTypes do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.UserResolver

  object :user do
    field(:id, :id)
    field(:username, :string)
    field(:password, :string)
    field(:email, :string)
    field(:age, :integer)
    field(:inserted_at, :string)
    field(:updated_at, :date_time)

    field(:user_cards, list_of(:card)) do
      resolve(&UserResolver.find_cards_for_user/3)
    end
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

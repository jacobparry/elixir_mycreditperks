defmodule Api.Schema.Queries.UserQueries do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.UserResolver

  object :user_queries do
    field(:users, list_of(:user)) do
      @desc "Matching a username"
      arg(:matching, :string)

      @desc "Orders by username"
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(&UserResolver.find_all_users/3)
    end

    field(:users_with_filters, list_of(:user)) do
      arg(:filter, :user_filter)
      resolve(&UserResolver.find_all_users_with_filters/3)
    end

    field(:users_with_non_null_filters, list_of(:user)) do
      arg(:filter, non_null(:user_filter))
      resolve(&UserResolver.find_all_users_with_filters/3)
    end

    field(:users_with_non_null_inner_filters, list_of(:user)) do
      arg(:filter, non_null(:user_filter_non_null_field))
      resolve(&UserResolver.find_all_users_with_filters/3)
    end
  end
end

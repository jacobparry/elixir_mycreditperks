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
  end
end

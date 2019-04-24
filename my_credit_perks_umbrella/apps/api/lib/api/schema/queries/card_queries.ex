defmodule Api.Schema.Queries.CardQueries do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.CardResolver

  object :card_queries do
    field(:cards, list_of(:card)) do
      resolve(&CardResolver.find_all_cards/3)
    end
  end
end

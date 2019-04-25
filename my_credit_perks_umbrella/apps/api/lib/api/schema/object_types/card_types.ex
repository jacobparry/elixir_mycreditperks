defmodule Api.Schema.ObjectTypes.CardTypes do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.CardResolver

  object :card do
    field(:id, :id)
    field(:name, :string)

    field(:users_that_have_card, list_of(:user)) do
      resolve(&CardResolver.find_users_for_card/3)
    end
  end
end

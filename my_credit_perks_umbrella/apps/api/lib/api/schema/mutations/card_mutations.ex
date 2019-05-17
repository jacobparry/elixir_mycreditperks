defmodule Api.Schema.Mutations.CardMutations do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.CardResolver

  object :card_mutations do
    field :create_card, :card do
      arg(:input, non_null(:create_card_input))
      resolve(&CardResolver.create_card/3)
    end
  end

  input_object :create_card_input do
    field(:name, non_null(:string))
  end
end

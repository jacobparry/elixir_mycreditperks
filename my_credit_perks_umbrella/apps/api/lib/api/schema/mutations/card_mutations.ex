defmodule Api.Schema.Mutations.CardMutations do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.CardResolver

  object :card_mutations do
    field :create_card, :card do
      arg(:input, non_null(:create_card_input))
      resolve(&CardResolver.create_card/3)
    end

    # Add a field here to add a card to a user
    # You will need to create an input object for the args
  end

  input_object :create_card_input do
    field(:name, non_null(:string))
  end

  # Create an input_object here for the args for adding a card to a user
end

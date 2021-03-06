defmodule Api.Schema.Mutations.UserMutations do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.UserResolver

  object :user_mutations do
    field :create_user, :user do
      arg(:input, non_null(:create_user_input))
      resolve(&UserResolver.create_user/3)
    end
  end

  input_object :create_user_input do
    field(:username, non_null(:string))
    field(:password, non_null(:string))
    field(:email, non_null(:string))
    field(:age, :integer)
  end
end

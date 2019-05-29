defmodule Api.Schema.Mutations.UserMutations do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.UserResolver

  object :user_mutations do
    field :create_user, :user do
      arg(:input, non_null(:create_user_input))
      resolve(&UserResolver.create_user/3)
    end

    field :create_user_better_errors, :user do
      arg(:input, non_null(:create_user_input))
      resolve(&UserResolver.create_user_better_errors/3)
    end

    field :create_user_best_errors, :create_user_result do
      arg(:input, non_null(:create_user_input_with_nulls))
      resolve(&UserResolver.create_user_best_errors/3)
    end

    field :update_user, :user do
      arg(:input, non_null(:update_user_input))
      resolve(&UserResolver.update_user/3)
    end
  end

  input_object :update_user_input do
    field(:id, non_null(:id))
    field(:username, :string)
    field(:password, :string)
    field(:email, :string)
    field(:age, :integer)
  end

  input_object :create_user_input do
    field(:username, non_null(:string))
    field(:password, non_null(:string))
    field(:email, non_null(:string))
    field(:age, :integer)
  end

  input_object :create_user_input_with_nulls do
    field(:username, :string)
    field(:password, :string)
    field(:email, :string)
    field(:age, :integer)
  end

  @desc "The results of trying to create a user. Either a user or a list of errors."
  object :create_user_result do
    field(:user, :user)
    field(:errors, list_of(:input_error))
  end

  @desc "An error encountered trying to persist input"
  object :input_error do
    field(:key, non_null(:string))
    field(:message, non_null(:string))
  end
end

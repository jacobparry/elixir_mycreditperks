defmodule Api.Schema.Mutations.UserMutations do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.UserResolver
  alias Api.Schema.Middleware

  object :user_mutations do
    field :create_user, :user do
      arg(:input, non_null(:create_user_input))
      resolve(&UserResolver.create_user/3)
    end

    field :create_user_better_errors, :user do
      arg(:input, non_null(:create_user_input))
      resolve(&UserResolver.create_user_better_errors/3)
    end

    field :create_user_restricted, :user do
      arg(:input, non_null(:create_user_input))
      resolve(&UserResolver.create_user_restricted/3)
    end

    field :create_user_with_middleware, :create_user_result do
      arg(:input, non_null(:create_user_input_with_nulls))
      resolve(&UserResolver.create_user_with_middleware/3)
      middleware(Middleware.ChangesetErrors)
    end

    field :create_user_best_errors, :create_user_result do
      arg(:input, non_null(:create_user_input_with_nulls))
      resolve(&UserResolver.create_user_best_errors/3)
    end

    field :update_user, :user do
      arg(:input, non_null(:update_user_input))
      resolve(&UserResolver.update_user/3)
    end

    field :update_user_trigger, :user do
      arg(:input, non_null(:update_user_input))
      resolve(&UserResolver.update_user_trigger/3)
    end

    field :login_user, :session do
      arg(:input, non_null(:login_input))
      resolve(&UserResolver.login_user/3)
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
    field(:role, non_null(:string))
    field(:new_password, non_null(:string))
  end

  input_object :create_user_input_with_nulls do
    field(:username, :string)
    field(:password, :string)
    field(:email, :string)
    field(:age, :integer)
    field(:new_password, :string)
    field(:role, :string)
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

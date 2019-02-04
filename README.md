# elixir_mycreditperks
A fun project designed to show cards and the perks associated with them.

# Setup
* Install Elixir, node, postgres

# Details
https://github.com/jacobparry/elixir_mycreditperks
  * In the github repo, there are Pull Requests made comparing each branch to the previous one

# 1.0-setup-elixir-umbrella-app
1. Run the following command in the repo 
  * `mix new [whatever the app name is]_umbrella --umbrella` 
  * This scaffolds an umbrella application.
  * Similar to a .NET Solutions.
  * Used for delineating logic or separating distince services (think micro services)


# 1.1-setup-elixir-logic-app
1. Navigate into the `[umbrella_app]/apps` directory
2. Run the following command
  * `mix new [logic-app-name] --sup`
  * A --sup option can be given to generate an OTP application skeleton including a supervision tree. Normally an app is generated without a supervisor and without the app callback.


# 1.2-setup-elixir-phoenix-app
1. Navigate into the `[umbrella_app]/apps` directory
2. Run the following commands
  * `mix archive.install hex phx_new 1.4.0`
  * `mix phx.new ui --no-ecto`
  * When asked, select `Y` or the default option for installing the dependencies.
  * The --no-ecto tells phoenix not to include the ecto wrapper or any of the files needed to interact with ecto.
3. Navigate into `[umbrella_app]/apps/ui/assets`
  * Run `npm install`
5. Test that everything works by navigating to the root `[umbrella_app]` and running `mix phx.server`.
    * Run `mix phx.server`
    * In a browser, open `localhost:4000`. You should see a default Phoenix app page.

# 1.3-setup-ecto
1. Navigate into the `[umbrella_app]/apps` directory
2. Run the following command
  * `mix new [database-app-name] --sup`
  * A --sup option can be given to generate an OTP application skeleton including a supervision tree. Normally an app is generated without a supervisor and without the app callback.
3. Open the file `[umbrella_app]/apps/[database_app]/mix.exs`
  * Add the following dependencies found on hex.pm to the dependency block:
    1. `{:ecto, "~> 3.0"}` or https://hex.pm/packages/ecto (for the latest)
    2. `{:ecto_sql, "~> 3.0"}` or https://hex.pm/packages/ecto_sql (for the latest)
    2. `{:postgrex, "~> 0.14.1"}` or https://hex.pm/packages/postgrex (for the latest)


4. Open the file `[umbrella_app]/apps/[database_app]/config/config.exs`
  * Add the following config blocks to the bottom of the file:
      ```
        config :[database_app], [DatabaseApp].Repo,
          adapter: Ecto.Adapters.Postgres,
          database: "my_credit_perks",
          username: "postgres",
          password: "postgres"
        
        config :[database_app], ecto_repos: [Db.Repo]
      ```
5. Create the file `[umbrella_app]/apps/[database_app]/lib/repo.ex`
  * Define the module as `[DatabaseApp].Repo`
  * Add this line: `use Ecto.Repo, otp_app: :elvenhearth`
    1. This defines this repo as an ecto repo.
```
defmodule Db.Repo do
  use Ecto.Repo, otp_app: :db
end
```

6. Open the file `[umbrella_app]/apps/[database_app]/lib/[database_app]/application.ex`
  * Inside of the `def start` function, add the following line as the first line inisde of it:
    1. `import Supervisor.Spec`
  * Inside of the `children = []` list in the `def start` function, add in:
    1. `worker([DatabaseApp].Repo, [])`
    2. This allows the repo to be restarted by a supervisor if it dies.

7. Run `mix ecto.create`
  * This will create the database as configured in step 2 above.
  * Running `mix ecto` will tell you the other tasks that ecto can perform`

# 1.4-setup-absinthe
1. Navigate into the `[umbrella_app]/apps` directory
2. Run the following command
  * `mix new [api-app-name] --sup`
  * A --sup option can be given to generate an OTP application skeleton including a supervision tree. Normally an app is generated without a supervisor and without the app callback.

3. Open the files `[umbrella_app]/apps/[api_app]/mix.exs` and `[umbrella_app]/apps/[ui_app]/mix.exs`
  * Add the following dependencies found on hex.pm to the dependency block:
```
    {:absinthe, "~> 1.4"},
    {:absinthe_plug, "~> 1.4"},
    {:absinthe_phoenix, "~> 1.4"},
    {:absinthe_relay, "~> 1.4"}
```
https://hex.pm/packages/absinthe for latest
https://hex.pm/packages/absinthe_plug for latest
https://hex.pm/packages/absinthe_phoenix for latest
https://hex.pm/packages/absinthe_relay for latest
  * Run `mix deps.get`

4. Open the file `[umbrella_app]/apps/[ui_app]/lib/[ui_app]/application.ex`
 * Inside of the `children = []` list in the `def start` function, add in:
    1. `supervisor(Absinthe.Subscription, [UiWeb.Endpoint])`
    2. This allows the app to be restarted by a supervisor if it dies.

5. Open the file `[umbrella_app]/apps/[ui_app]/lib/[ui_app]_web/channels/user_socket.ex`
  * At the top of the module, inside of the `defmodule do`, add:
    1. `use Absinthe.Phoenix.Socket, schema: ElvenhearthPhxWeb.Schema`
    2. This allows subscriptions to work.


6. Open the file `[umbrella_app]/apps/[ui_app]/lib/[ui_app]_web/router.ex`
  * Add the graphiql route to the router:
    1. 
      ```
        scope "/playground" do
          pipe_through :api

          forward("/graphiql", Absinthe.Plug.GraphiQL,
            schema: ElvenhearthPhxWeb.Schema,
            interface: :playground
          )
        end
      ```

7. Create the file `[umbrella_app]/apps/[api_app]/lib/[api_app]/schema.ex`
  * `defmodule [ApiApp].Schema do`
  * Add `use Absinthe.Schema` at the top of the module
  * Add this simple query:
    1. 
      ```
        query do
          field :health, :string do
            resolve(fn _, _, _ ->
              {:ok, "up"}
            end)
          end
        end
      ```

6. From `[umbrella_app]`, run the following command:
  * `mix phx.server`
  * Now navigate to localhost:4000/playground/graphiql
  * You can explore this interface that will come into play later.


# 2.0--ecto-models-user
1. Create a `User` Model
  * Create a new folder and file `models/user.ex` (if it doesnt exist) at `[umbrella_app]/apps/[database_app]/lib//models/user.ex`
```
defmodule Db.Models.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    ###### 2.0-ecto-models-user
    field(:username, :string)
    field(:password, :string)
    field(:email, :string)
    field(:age, :integer)
    timestamps()
    ###################
  end

  @required_fields [:username, :password, :email]
  @optional_fields [:age]

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
```

# 2.1--ecto-models-card
1. Create a `Card` Model
  * Create a new folder and file `models/card.ex` (if it doesnt exist) at `[umbrella_app]/apps/[database_app]/lib/models/card.ex`
```
defmodule Db.Models.Card do
  use Ecto.Schema

  import Ecto.Changeset

  schema "cards" do
    ###### 2.1-ecto-models-card
    field(:name)
    timestamps()
    ###################

    @required_fields [:name]
    @optional_fields []

    def changeset(card, params \\ %{}) do
      card
      |> cast(params, @required_fields ++ @optional_fields)
      |> validate_required(@required_fields)
    end
  end
end
```

# 2.2--ecto-models-user-card
1. Create a `Card` Model
  * Create a new folder (if it doesnt exist) and file `models/card.ex` at `[umbrella_app]/apps/[database_app]/lib/models/user_card.ex`
```
defmodule Db.Models.UserCard do
  use Ecto.Schema

  import Ecto.Changeset

  schema "user_cards" do
    ###### 2.2-ecto-models-user-cards
    belongs_to(:user, Db.Models.User)
    belongs_to(:card, Db.Models.Card)
    timestamps()
    ###################

    @required_fields [
      :user_id,
      :card_id
    ]
    @optional_fields []

    def changeset(card, params \\ %{}) do
      card
      |> cast(params, @required_fields ++ @optional_fields)
      |> validate_required(@required_fields)
    end
  end
end
```

# 2.3-ecto-models-perks
1. Create a `Perk` Model
  * In the `card` model, add the following into the schemal:
    ```
    ###### 2.3-ecto-models-perks
    has_many(:perks, Db.Models.Perk)
    ###################
    ```
  * Create a new folder (if it doesnt exist) and file `models/perk.ex` at `[umbrella_app]/apps/[database_app]/lib/models/perk.ex`
```
defmodule Db.Models.Perk do
  use Ecto.Schema

  import Ecto.Changeset

  schema "perks" do
    ###### 2.3-ecto-models-perks
    field(:type, :string)
    field(:description, :string)
    timestamps()

    belongs_to(:card, Db.Models.Card)
    ###################

    @required_fields [
      :type,
      :description
    ]
    @optional_fields []

    def changeset(card, params \\ %{}) do
      card
      |> cast(params, @required_fields ++ @optional_fields)
      |> validate_required(@required_fields)
    end
  end
end
```


# 2.4-ecto-migrations
  * Navigate to `[umbrella_app]/apps/[database_app]`
    1. Run `mix ecto.gen.migration add_users_table`:
      * Add the following to the `def change do` in the generated migration file
        ```
          create table(:users) do
            add :username, :string, size: 50
            add :password, :string, size: 100
            add :email, :string, size: 50
            add :age, :integer

            timestamps()
          end
        ```
    2. Run `mix ecto.gen.migration add_cards_table`:
      * Add the following to the `def change do` in the generated migration file
        ```
        create table(:cards) do
            add(:name, :string)
            timestamps()
        end
        ```
    3. Run `mix ecto.gen.migration add_user_cards_table`:
      * Add the following to the `def change do` in the generated migration file
        ```
        create table(:user_cards) do
            add(:user_id, references(:users, on_delete: :nothing))
            add(:card_id, references(:cards, on_delete: :nothing))

            timestamps()
        end
        ```
    4. Run `mix ecto.gen.migration add_perks_table`:
      * Add the following to the `def change do` in the generated migration file
        ```
        create table(:perks) do
            add(:type, :string)
            add(:description, :string)
            add(:card_id, references(:cards, on_delete: :nothing))

            timestamps()
        end
        ```
  * Run `mix ecto.migrate` to run create tables in the database.
    * If you open postgres by running `psql -d [database name], you will see 3 tables:
    1. `characters` and `users`
        * By running `\d characters` you will see that a Foreign key has been added for users.
    2. `schema_migrations`
        * This is how the app keeps track of what migrations have been run.


# 2.5-ecto-seeds
  * Navigate to `[umbrella_app]/apps/[database_app]/lib`
    1. Create a file called `seeds.ex`. 
      * We will use this file to seed things (for now) in our database for our tests and our Graphiql IDE queries.
    2. Define the module `Db.Seeds` and write some seeding functions. Your file will look something similar to this:

    ```
    defmodule Db.Seeds do
      alias Db.Models.{
        Card,
        Perk,
        User,
        UserCard
      }

      alias Db.Repo

      def run() do
        seed_users()
        seed_cards()
      end

      defp seed_users() do
        users = [
          User.changeset(%User{}, %{
            username: "test_1",
            password: "very_secure_password",
            email: "test_1@test.com"
          }),
          User.changeset(%User{}, %{
            username: "test_2",
            password: "very_secure_password",
            email: "test_2@test.com"
          }),
          User.changeset(%User{}, %{
            username: "test_3",
            password: "very_secure_password",
            email: "test_3@test.com"
          })
        ]

        inserted_users =
          Enum.map(users, fn user ->
            Repo.insert(user)
          end)
      end

      defp seed_cards() do
        cards = [
          Card.changeset(%Card{}, %{
            name: "Chase Sapphire Preferred"
          }),
          Card.changeset(%Card{}, %{
            name: "Citi Costco Visa"
          }),
          Card.changeset(%Card{}, %{
            name: "American Express Gold"
          })
        ]

        inserted_cards =
          Enum.map(cards, fn card ->
            Repo.insert(card)
          end)
      end
    end
    ```

# 2.6-setup-tests
  * One thing that we have neglected to do up until this point was to write some tests. Let's correct that.
  * We need to write tests for our DB models and our single health field in our GraphQL schema.
  1. Create a folder called `models` located at `[umbrella_app]/apps/[database_app]/test/models`.
  2. Create a file named `user_test.exs` located at `[umbrella_app]/apps/[database_app]/models/user_test.exs`
    * Write some tests that test the functionality of the `user.ex` ecto changeset function.
    * The file will look something like this:
    ```
    defmodule Db.Models.UserTest do
      use ExUnit.Case
      alias Db.Models.User

      describe "changeset/2" do
        test "returns a valid changeset" do
          params = %{
            username: "user_1",
            password: "password_1",
            email: "email_1",
            age: "21"
          }

          changeset = User.changeset(%User{}, params)
          assert changeset.valid?
        end

        test "a missing USERNAME returns an invalid changeset" do
          params = %{
            password: "password_1",
            email: "email_1",
            age: "21"
          }

          changeset = User.changeset(%User{}, params)
          refute changeset.valid?
        end

        test "a missing PASSWORD returns an invalid changeset" do
          params = %{
            username: "user_1",
            email: "email_1",
            age: "21"
          }

          changeset = User.changeset(%User{}, params)
          refute changeset.valid?
        end

        test "a missing EMAIL returns an invalid changeset" do
          params = %{
            username: "user_1",
            password: "password_1",
            age: "21"
          }

          changeset = User.changeset(%User{}, params)
          refute changeset.valid?
        end

        test "a missing AGE still returns a valid changeset" do
          params = %{
            username: "user_1",
            password: "password_1",
            email: "email_1"
          }

          changeset = User.changeset(%User{}, params)
          assert changeset.valid?
        end
      end
    end
    ```
  3. Once you have done that, create test files for all the models that we created:`card_test.ex`, `perk_test.ex`, `user_card_test.exs`. They will all follow a similar style of testing.
  4. Add an api endpoint for our tests to hit for testing Graphql queries  
    * Navigate to `[umbrella_app]/apps/[ui_app]/lib/ui_web/router.ex`
    * Inside of the scope that we defined earlier, we will add another forward.
    * `forward("/api", Absinthe.Plug, schema: Api.Schema)`
    * This creates the endpoint that an API client and our tests will use.
  5. Write a simple test that tests our `health` field in our Absinthe Schema file.
    * Navigate to `[umbrella_app]/apps/[api]/mix.exs`
    * Add `{:ui, in_umbrella: true}` inside of the `deps` function. This allows us to use Phoenix to help test our api endpoint.
    * Create a file named `schema_test.exs` located at `[umbrella_app]/apps/[api_app]/test/api/schema_test.exs`
    * The file will look like this:
    ```
    defmodule Api.SchemaTest do
      use ExUnit.Case

      # UiWeb.ConnCase allows us to build a connection and post it against an api endpoint
      # This allows us to test our GraphQL queries
      use UiWeb.ConnCase, async: true

      @query """
      {
        health
      }
      """

      describe "query" do
        test "health" do
          conn = build_conn()
          conn = get(conn, "/playground/api", query: @query)

          response = json_response(conn, 200)
          assert response == %{"data" => %{"health" => "up"}}
        end
      end
    end
    ```

# 3.0-query-basics
  1. Added documentation to the schema file describing things.
  ```
  defmodule Api.Schema do
    use Absinthe.Schema

    """
    Keep in mind that your API and the underlying data representations
    do not need to be identical, or even have the same structure.
    One of the main values in modeling GraphQL types is that they
    can serve as an abstraction over whatever backing data store (or
    service) contains the associated data, transforming it before it’s
    transmitted to API users.
    """

    query do
      # The second arg defines the field type. This is by default a scalar value.
      # Absinthe has some defined build in: :integer, :float, :string, :boolean, :null, :id.
      # Can add custom scalar types
      field :health, :string,
        # Description is documation we can provide for and object type/field that will be available via introspection
        description: "Tests whether the GraphQL schema and endpoint are configured correctly.",

        # Name is required, but generated automatically if not manually specified.
        name: "healthy" do
        resolve(fn _, _, _ ->
          {:ok, "yup"}
        end)
      end
    end
  end
  ```
# elixir_mycreditperks
A fun project designed to show cards and the perks associated with them.

# Setup
* Install Elixir, node, postgres
* mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

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
2. Run the following command
  * `mix phx.new ui --no-ecto`
  * When asked, select `Y` or the default option for installing the dependencies.
  * The --no-ecto tells phoenix not to include the ecto wrapper or any of the files needed to interact with ecto.
3. Navigate into `[umbrella_app]/apps/ui/assets`
  * Run `npm install`
4. Open  `[umbrella_app]/apps/ui/mix.exs`
    * Under `deps`, add `{:plug_cowboy, "~> 1.0"}`
5. Test that everything works by navigating to the root `[umbrella_app]` and running `mix phx.server`.
    * Run `mix phx.server`
    * In a browser, open `localhost:4000`. You should see a default Phoenix app page.

# 1.3-setup-ecto
1. Navigate into the `[umbrella_app]/apps` directory
2. Run the following command
  * `mix new [database-app-name] --sup`
  * A --sup option can be given to generate an OTP application skeleton including a supervision tree. Normally an app is generated without a supervisor and without the app callback.
1. Open the file `[umbrella_app]/apps/[database_app]/mix.exs`
  * Add the following dependencies found on hex.pm to the dependency block:
    1. `{:ecto, "~> 3.0"}` or https://hex.pm/packages/ecto (for the latest)
    2. `{:ecto_sql, "~> 3.0"}` or https://hex.pm/packages/ecto_sql (for the latest)
    2. `{:postgrex, "~> 0.14.1"}` or https://hex.pm/packages/postgrex (for the latest)


2. Open the file `[umbrella_app]/apps/[database_app]/config/config.exs`
  * Add the following config blocks to the bottom of the file:
      ```
        config :[database_app], [DatabaseApp].Repo,
          adapter: Ecto.Adapters.Postgres,
          database: "my_credit_perks",
          username: "postgres",
          password: "postgres"
        
        config :[database_app], ecto_repos: [Db.Repo]
      ```
3. Create the file `[umbrella_app]/apps/[database_app]/lib/repo.ex`
  * Define the module as `[DatabaseApp].Repo`
  * Add this line: `use Ecto.Repo, otp_app: :elvenhearth`
    1. This defines this repo as an ecto repo.
```
defmodule Db.Repo do
  use Ecto.Repo, otp_app: :db
end
```

4. Open the file `[umbrella_app]/apps/[database_app]/lib/[database_app]/application.ex`
  * Inside of the `def start` function, add the following line as the first line inisde of it:
    1. `import Supervisor.Spec`
  * Inside of the `children = []` list in the `def start` function, add in:
    1. `worker([DatabaseApp].Repo, [])`
    2. This allows the repo to be restarted by a supervisor if it dies.

5. Run `mix ecto.create`
  * This will create the database as configured in step 2 above.
  * Running `mix ecto` will tell you the other tasks that ecto can perform`
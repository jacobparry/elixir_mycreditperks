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
  * `mix new [app-name] --sup`
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



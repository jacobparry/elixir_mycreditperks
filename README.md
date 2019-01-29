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
  * `mix new [app-name] --sup`
  * A --sup option can be given to generate an OTP application skeleton including a supervision tree. Normally an app is generated without a supervisor and without the app callback.

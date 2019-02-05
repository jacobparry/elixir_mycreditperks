defmodule MyCreditPerksUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end

  # These aliases can only be called from the root of the umbrella project.
  # If you want to call them elsewhere, then they need added to that app's mix.exs file.
  defp aliases do
    [
      {:setup, ["ecto.drop", "ecto.create", "ecto.migrate"]},
      {:reset, ["ecto.drop", "ecto.create", "ecto.migrate", "run -e Db.Seeds.run()"]},
      {:seed, "run -e Db.Seeds.run()"},
      {:test, ["ecto.create --quiet", "ecto.migrate", "test"]}
    ]
  end
end

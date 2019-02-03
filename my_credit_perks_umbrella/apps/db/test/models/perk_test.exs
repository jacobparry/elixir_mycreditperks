defmodule Db.Models.PerkTest do
  use ExUnit.Case
  alias Db.Models.Perk

  describe "changeset/2" do
    test "returns a valid changeset" do
      params = %{type: "Travel", description: "Travel Insurance"}
      changeset = Perk.changeset(%Perk{}, params)

      assert changeset.valid?
    end

    test "a missing TYPE returns an invalid changeset" do
      params = %{description: "Travel Insurance"}
      changeset = Perk.changeset(%Perk{}, params)

      refute changeset.valid?
    end

    test "a missing DESCRIPTION returns an invalid changeset" do
      params = %{type: "Travel"}
      changeset = Perk.changeset(%Perk{}, params)

      refute changeset.valid?
    end
  end
end

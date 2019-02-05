defmodule Db.Models.CardTest do
  use Db.RepoCase
  alias Db.Models.Card

  describe "changeset/2" do
    test "returns a valid changeset" do
      params = %{name: "Card_01"}
      changeset = Card.changeset(%Card{}, params)

      assert changeset.valid?
    end

    test "a missing NAME returns an invalid changeset" do
      params = %{}
      changeset = Card.changeset(%Card{}, params)

      refute changeset.valid?
    end
  end
end

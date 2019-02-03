defmodule Db.Models.UserCardTest do
  use ExUnit.Case
  alias Db.Models.UserCard

  describe "changeset/2" do
    test "returns a valid changeset" do
      params = %{user_id: 1, card_id: 1}
      changeset = UserCard.changeset(%UserCard{}, params)

      assert changeset.valid?
    end

    test "a missing USER_ID returns an invalid changeset" do
      params = %{card_id: 1}
      changeset = UserCard.changeset(%UserCard{}, params)

      refute changeset.valid?
    end

    test "a missing CARD_ID returns an invalid changeset" do
      params = %{user_id: 1}
      changeset = UserCard.changeset(%UserCard{}, params)

      refute changeset.valid?
    end
  end
end

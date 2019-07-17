defmodule CreditPerks.Contexts.CardsContextTest do
  use CreditPerks.Case
  alias CreditPerks.Contexts.CardsContext

  alias Db.Models.Card

  @valid_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "cards" do
    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CardsContext.create_card()

      {:ok, card}
    end

    test "list_cards/0 returns all cards" do
      {:ok, card} = card_fixture()

      CardsContext.list_cards()
      assert CardsContext.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      {:ok, card} = card_fixture()
      assert CardsContext.get_card(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = CardsContext.create_card(@valid_attrs)
      assert card.name == "some name"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CardsContext.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      {:ok, card} = card_fixture()

      CardsContext.update_card(card, @update_attrs)

      assert {:ok, %Card{} = card} = CardsContext.update_card(card, @update_attrs)
      assert card.name == "some updated name"
    end

    test "update_card/2 with invalid data returns error changeset" do
      {:ok, card} = card_fixture()
      assert {:error, %Ecto.Changeset{}} = CardsContext.update_card(card, @invalid_attrs)
      assert card == CardsContext.get_card(card.id)
    end

    test "delete_card/1 deletes the card" do
      {:ok, card} = card_fixture()
      assert {:ok, %Card{}} = CardsContext.delete_card(card)

      assert_raise Ecto.NoResultsError, fn ->
        CardsContext.get_card!(card.id)
        # |> IO.inspect()
      end
    end

    test "change_card/1 returns a card changeset" do
      {:ok, card} = card_fixture()
      assert %Ecto.Changeset{} = CardsContext.change_card(card)
    end
  end
end

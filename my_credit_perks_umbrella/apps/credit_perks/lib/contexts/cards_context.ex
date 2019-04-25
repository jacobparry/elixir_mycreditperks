defmodule CreditPerks.Contexts.CardsContext do
  @moduledoc """
  The CardsContext context.
  """

  import Ecto.Query, warn: false
  alias Db.Repo
  alias Db.Models.Card

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(from(Card))
  end

  @doc """
  Gets a single card.

  Returns nil if the Card does not exist.

  ## Examples

      iex> get_card(123)
      nil

  """
  def get_card(id) do
    query =
      from(c in Card,
        where: c.id == ^id
      )

    Repo.one(query)
  end

  @doc """
  Gets a single card.

  Raises if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

  """
  def get_card!(id) do
    query =
      from(c in Card,
        where: c.id == ^id
      )

    Repo.one!(query)
  end

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, ...}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, ...}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, ...}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns a data structure for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Todo{...}

  """
  def change_card(%Card{} = card) do
    Card.changeset(card, %{})
  end
end

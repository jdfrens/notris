defmodule Notris.Bottom do
  @moduledoc """
  Helper functions for the bottom of a `Notris.Board`.

  The bottom of a board consists of the dead pieces left over when they reach the bottom.
  """

  alias Notris.{Color, Location, Piece}

  @type t :: %{required(Location.t()) => Color.t()}

  @spec locations_of(t()) :: list(Location.t())
  def locations_of(bottom) do
    Map.keys(bottom)
  end

  @spec add_piece(t(), Piece.t(), Location.t()) :: t()
  def add_piece(%{} = bottom, %Piece{} = piece, %Location{} = location) do
    piece
    |> Piece.to_bottom(location)
    |> Map.merge(bottom)
  end

  @spec eliminate_full_rows(t(), pos_integer(), pos_integer()) :: t()
  def eliminate_full_rows(%{} = bottom, width, height) do
    bottom
    |> find_full_rows(width, height)
    |> Enum.reduce(bottom, fn row, acc ->
      remove_and_adjust_rows(acc, row)
    end)
  end

  @spec find_full_rows(t(), integer(), integer()) :: list(integer())
  defp find_full_rows(%{} = bottom, width, height) do
    1..height
    |> Enum.reduce([], fn row, acc ->
      cond do
        row > height -> acc
        filled_row?(bottom, width, row) -> [row | acc]
        true -> acc
      end
    end)
    |> Enum.reverse()
  end

  defp filled_row?(bottom, width, row) do
    Enum.all?(1..width, &Map.has_key?(bottom, Location.new(&1, row)))
  end

  @down_one_row Notris.Offset.new(0, +1)

  @spec remove_and_adjust_rows(t(), integer()) :: t()
  defp remove_and_adjust_rows(bottom, full_row) do
    Enum.reduce(bottom, %{}, fn {location, value}, acc ->
      cond do
        location.row == full_row ->
          acc

        location.row < full_row ->
          adjusted_location = Location.offset(location, @down_one_row)
          Map.put(acc, adjusted_location, value)

        true ->
          Map.put(acc, location, value)
      end
    end)
  end
end

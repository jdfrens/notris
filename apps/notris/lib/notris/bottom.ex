defmodule Notris.Bottom do
  @moduledoc """
  Helper functions for the bottom of a `Notris.Board`.

  The bottom of a board consists of the dead pieces left over when they reach the bottom.
  """

  alias Notris.{Color, Location, Piece}

  @type t :: %{Location.t() => Color.t()}

  @spec locations_of(t()) :: list(Location.t())
  def locations_of(bottom) do
    Map.keys(bottom)
  end

  @spec add_piece(t(), Piece.t(), Location.t()) :: t()
  def add_piece(bottom, %Piece{} = piece, %Location{} = location) do
    piece
    |> Piece.to_bottom(location)
    |> Map.merge(bottom)
  end
end

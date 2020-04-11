defmodule Notris do
  @moduledoc """
  API for Notris.
  """

  @spec rotate_right(Notris.Piece.t()) :: Notris.Piece.t()
  defdelegate rotate_right(piece), to: Notris.Piece

  @spec rotate_left(Notris.Piece.t()) :: Notris.Piece.t()
  defdelegate rotate_left(piece), to: Notris.Piece
end

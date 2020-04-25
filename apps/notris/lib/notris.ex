defmodule Notris do
  @moduledoc """
  API for Notris.
  """


  @type bottom :: Notris.Bottom.t()
  @type color :: Notris.Color.t()
  @spec rotate_right(Notris.Piece.t()) :: Notris.Piece.t()
  defdelegate rotate_right(piece), to: Notris.Piece

  @spec rotate_left(Notris.Piece.t()) :: Notris.Piece.t()
  defdelegate rotate_left(piece), to: Notris.Piece
end

defmodule Notris.Board do
  @moduledoc """
  Model for the board of a game.
  """

  @enforce_keys ~w(width height points)a
  defstruct width: 0, height: 0, points: %{}

  @type t :: %__MODULE__{
          width: pos_integer(),
          height: pos_integer(),
          points: list(Point.location())
        }

  @spec collides?(t(), Point.location()) :: boolean()
  def collides?(board, {col, row}) do
    col not in 1..board.width or row not in 1..board.height
  end
end

defmodule Notris.Game do
  @moduledoc """
  Representation of a Notris game.
  """

  alias Notris.{Board, Game, Piece, Point}

  @enforce_keys ~w(board)a
  defstruct [:piece, :location, :board]

  @type t :: %__MODULE__{
          piece: Piece.t() | nil,
          location: Point.location() | nil,
          board: Board.t()
        }

  @doc """
  Creates a new game.
  """
  @spec new(Board.t()) :: t()
  def new(%Board{} = board) do
    %Game{piece: nil, location: nil, board: board}
  end

  @doc """
  Adds a new current piece to the game.

  There can be _no_ current piece when this function is called.
  """
  @spec add(t(), Piece.t(), Point.location()) :: t()
  def add(%Game{piece: nil, location: nil} = game, %Piece{} = piece, location) do
    %{game | piece: piece, location: location}
  end
end

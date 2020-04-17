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

  @doc """
  Maybe moves the current piece to the left.

  The game is updated with the new location if the piece _can_ be moved to the left.  If it cannot be moved to the left,
  the same game is returned.
  """
  @spec maybe_move_left(t()) :: t()
  def maybe_move_left(game) do
    maybe_move_horizontal(game, -1)
  end

  @doc """
  Maybe moves the current piece to the right.

  The game is updated with the new location if the piece _can_ be moved to the right.  If it cannot be moved to the right,
  the same game is returned.
  """
  @spec maybe_move_right(t()) :: t()
  def maybe_move_right(game) do
    maybe_move_horizontal(game, +1)
  end

  defp maybe_move_horizontal(game, offset) do
    %Game{board: board, piece: piece, location: {col, row}} = game
    maybe_location = {col + offset, row}

    if collides?(board, piece, maybe_location) do
      game
    else
      %{game | location: maybe_location}
    end
  end

  defp collides?(board, piece, location) do
    piece
    |> Piece.points_at(location)
    |> Enum.any?(&Board.collides?(board, &1))
  end
end

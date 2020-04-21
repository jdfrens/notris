defmodule Notris.Game do
  @moduledoc """
  Representation of a Notris game.
  """

  alias Notris.{Board, Game, Location, Offset, Piece}

  @enforce_keys ~w(board game_over)a
  defstruct [:piece, :location, :board, :game_over]

  @type t :: %__MODULE__{
          piece: Piece.t() | nil,
          location: Location.t() | nil,
          board: Board.t(),
          game_over: boolean()
        }

  @doc """
  Creates a new game.
  """
  @spec new(Board.t()) :: t()
  def new(%Board{} = board) do
    %Game{piece: nil, location: nil, board: board, game_over: false}
  end

  @doc """
  Adds a new current piece to the game.

  There can be _no_ current piece when this function is called.
  """
  @spec add(t(), Piece.t(), Location.t()) :: t()
  def add(%Game{piece: nil, location: nil} = game, %Piece{} = piece, %Location{} = location) do
    %{game | piece: piece, location: location}
  end

  @doc """
  Maybe moves the current piece to the left.

  The game is updated with the new location if the piece _can_ be moved to the left.  If it cannot be moved to the left,
  the same game is returned.
  """
  @spec maybe_move_left(t()) :: t()
  def maybe_move_left(game) do
    maybe_move_horizontal(game, Offset.new(-1, 0))
  end

  @doc """
  Maybe moves the current piece to the right.

  The game is updated with the new location if the piece _can_ be moved to the right.  If it cannot be moved to the right,
  the same game is returned.
  """
  @spec maybe_move_right(t()) :: t()
  def maybe_move_right(game) do
    maybe_move_horizontal(game, Offset.new(+1, 0))
  end

  @doc """
  Maybe moves the current piece down.

  The game is updated with the new location if the piece _can_ be moved down.  If it cannot be moved down, piece is
  added to the bottom of the board while the `piece` and `location` are both set to `nil`.
  """
  @spec maybe_move_down(t()) :: t()
  def maybe_move_down(%Game{} = game) do
    %Game{board: board, piece: piece, location: location} = game
    maybe_location = Location.new(location.col, location.row + 1)

    if collides?(board, piece, maybe_location) do
      if game_over?(piece, location) do
        %{game | game_over: true}
      else
        %{game | piece: nil, location: nil}
      end
    else
      %{game | location: maybe_location}
    end
  end

  @spec maybe_move_horizontal(Game.t(), Offset.t()) :: Game.t()
  defp maybe_move_horizontal(%Game{} = game, %Offset{} = offset) do
    %Game{board: board, piece: piece, location: location} = game
    maybe_location = Location.offset(location, offset)

    if collides?(board, piece, maybe_location) do
      game
    else
      %{game | location: maybe_location}
    end
  end

  @spec collides?(Board.t(), Piece.t(), Location.t()) :: boolean()
  defp collides?(%Board{} = board, %Piece{} = piece, %Location{} = location) do
    piece
    |> Piece.locations_at(location)
    |> Enum.any?(&Board.collides?(board, &1))
  end

  @spec game_over?(Piece.t(), Location.t()) :: boolean()
  defp game_over?(piece, location) do
    piece
    |> Piece.locations_at(location)
    |> Enum.map(& &1.row)
    |> Enum.any?(&(&1 <= 0))
  end
end

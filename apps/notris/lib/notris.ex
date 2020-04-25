defmodule Notris do
  @moduledoc """
  API for Notris.
  """

  alias Notris.{Board, Game, Piece}

  @type bottom :: Notris.Bottom.t()
  @type color :: Notris.Color.t()

  @doc """
  Creates a new game.

  The `dimensions` are a tuple of width and height.  This is the size of the _board_, not the size of the display.
  (Display concerns are _not_ handled in `Notris`.)
  """
  @spec new_game({width :: non_neg_integer(), height :: non_neg_integer()}) ::
          {:ok, Game.t()} | {:error, any()}
  def new_game(dimensions) do
    with {:ok, board} <- Board.new(dimensions) do
      {:ok, Game.new(board)}
    end
  end

  @spec maybe_move_left(Game.t()) :: Game.t()
  defdelegate maybe_move_left(game), to: Notris.Game

  @spec maybe_move_down(Game.t()) :: Game.t()
  defdelegate maybe_move_down(game), to: Notris.Game

  @spec piece_as_bottom(Game.t()) :: bottom()
  def piece_as_bottom(game) do
    Piece.to_bottom(game.piece, game.location)
  end

  @doc """
  Returns the bottom of the board which consists of old, broken pieces.

  The data is an Enumerable mapping `{column, row}` to `{color}`.  `column` and `row` are non-negative integers; `color`
  is an atom.
  """
  @spec bottom_of(Game.t()) :: bottom()
  def bottom_of(%Game{} = game) do
    game.board.bottom
  end
end

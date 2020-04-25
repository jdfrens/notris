defmodule Notris do
  @moduledoc """
  API for Notris.
  """

  alias Notris.{Board, Bottom, Color, Game}

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
    with {:ok, board} <- Board.new(dimensions),
         filled_board = fill_random_bottom(board) do
      Game.new(filled_board)
    end
  end

  @doc """
  Returns the bottom of the board which consists of old, broken pieces.

  The data is an Enumerable mapping `{column, row}` to `{color}`.  `column` and `row` are non-negative integers; `color`
  is an atom.
  """
  @spec bottom_of(Game.t()) :: Bottom.t()
  def bottom_of(%Game{} = game) do
    game.board.bottom
  end

  @spec rotate_right(Notris.Piece.t()) :: Notris.Piece.t()
  defdelegate rotate_right(piece), to: Notris.Piece

  @spec rotate_left(Notris.Piece.t()) :: Notris.Piece.t()
  defdelegate rotate_left(piece), to: Notris.Piece

  @spec fill_random_bottom(Board.t()) :: Board.t()
  defp fill_random_bottom(%Board{} = board) do
    new_bottom =
      Enum.map(1..10, fn _i ->
        col = Enum.random(1..board.width)
        row = Enum.random(1..board.height)
        color = Enum.random(Color.values())
        {{col, row}, color}
      end)
      |> Enum.into(board.bottom)

    %{board | bottom: new_bottom}
  end
end

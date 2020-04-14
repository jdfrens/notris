defmodule Notris.Board do
  @moduledoc """
  Model for the board of a game.
  """

  alias Notris.{Board, Color, Piece, Point}

  @enforce_keys ~w(width height points)a
  defstruct width: 0, height: 0, points: %{}

  @type width :: pos_integer()
  @type height :: pos_integer()
  @type board_points :: %{Point.location() => Color.t()}

  @type t :: %__MODULE__{
          width: pos_integer(),
          height: pos_integer(),
          points: board_points()
        }

  @doc """
  Creates a new board with minimal validations on its parameters.
  """
  @spec new({width(), height()}, board_points()) ::
          {:ok, t()}
          | {:error, {:invalid_width, any()}}
          | {:error, {:invalid_height, any()}}
          | {:error, {:invalid_board_points, any()}}
  def new({width, height}, board_points \\ %{}) do
    with :ok <- valid_width(width),
         :ok <- valid_height(height),
         :ok <- valid_board_points(board_points) do
      %Board{width: width, height: height, points: board_points}
    end
  end

  @doc """
  Adds a `piece` to the `board` at a `location`.
  """
  @spec add(t(), Point.location(), Piece.t()) :: t()
  def add(board, location, piece) do
    piece_locations = Piece.board_points_at(piece, location)
    new_points = Map.merge(board.points, piece_locations)
    %{board | points: new_points}
  end

  @doc """
  Checks if the `point` collides with the boarder or a fallen point on the `board`.
  """
  @spec collides?(t(), Point.location()) :: boolean()
  def collides?(board, point) do
    collides_boarder?(board, point) or point in board.points
  end

  defp collides_boarder?(board, {col, row}) do
    col not in 1..board.width or row not in 1..board.height
  end

  defp valid_width(width) when is_integer(width) and width > 0, do: :ok
  defp valid_width(width), do: {:error, {:invalid_width, width}}

  defp valid_height(height) when is_integer(height) and height > 0, do: :ok
  defp valid_height(height), do: {:error, {:invalid_height, height}}

  defp valid_board_points(board_points) when is_map(board_points), do: :ok
  defp valid_board_points(board_points), do: {:error, {:invalid_board_points, board_points}}
end

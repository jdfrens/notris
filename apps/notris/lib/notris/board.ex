defmodule Notris.Board do
  @moduledoc """
  Model for the board of a game.
  """

  alias Notris.{Board, Bottom, Location, Piece}

  @enforce_keys ~w(width height bottom)a
  defstruct width: 0, height: 0, bottom: %{}

  @type width :: pos_integer()
  @type height :: pos_integer()

  @type t :: %__MODULE__{
          width: pos_integer(),
          height: pos_integer(),
          bottom: Bottom.t()
        }

  @doc """
  Creates a new board with minimal validations on its parameters.
  """
  @spec new({width(), height()}, Bottom.t()) ::
          {:ok, t()}
          | {:error, {:invalid_width, any()}}
          | {:error, {:invalid_height, any()}}
          | {:error, {:invalid_bottom, any()}}
  def new({width, height}, bottom \\ %{}) do
    with :ok <- valid_width(width),
         :ok <- valid_height(height),
         :ok <- valid_bottom(bottom) do
      {:ok, %Board{width: width, height: height, bottom: bottom}}
    end
  end

  @spec start_location(t()) :: Location.t()
  def start_location(%Board{} = board) do
    middle_col = div(board.width, 2)
    off_board_row = -4
    Location.new(middle_col, off_board_row)
  end

  @doc """
  Adds a `piece` to the bottom of the `board` at a `location`.
  """
  @spec add_to_bottom(t(), Piece.t(), Location.t()) :: t()
  def add_to_bottom(%Board{} = board, %Piece{} = piece, %Location{} = location) do
    new_bottom = Bottom.add_piece(board.bottom, piece, location)
    %{board | bottom: new_bottom}
  end

  @doc """
  Checks if the `location` collides with the border or the bottom of the `board`.
  """
  @spec collides?(t(), Location.t()) :: boolean()
  def collides?(%Board{} = board, %Location{} = location) do
    collides_border?(board, location) or location in Bottom.locations_of(board.bottom)
  end

  @doc """
  Eliminates full rows from the bottom.
  """
  @spec eliminate_full_rows(t()) :: t()
  def eliminate_full_rows(%Board{} = board) do
    %{board | bottom: Bottom.eliminate_full_rows(board.bottom, board.width, board.height)}
  end

  defp collides_border?(board, %Location{} = location) do
    location.col not in 1..board.width or location.row > board.height
  end

  defp valid_width(width) when is_integer(width) and width > 0, do: :ok
  defp valid_width(width), do: {:error, {:invalid_width, width}}

  defp valid_height(height) when is_integer(height) and height > 0, do: :ok
  defp valid_height(height), do: {:error, {:invalid_height, height}}

  defp valid_bottom(bottom) when is_map(bottom), do: :ok
  defp valid_bottom(bottom), do: {:error, {:invalid_bottom, bottom}}
end

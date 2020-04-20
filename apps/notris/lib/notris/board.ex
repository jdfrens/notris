defmodule Notris.Board do
  @moduledoc """
  Model for the board of a game.
  """

  alias Notris.{Board, Color, Location, Piece}

  @enforce_keys ~w(width height bottom)a
  defstruct width: 0, height: 0, bottom: %{}

  @type width :: pos_integer()
  @type height :: pos_integer()
  @type bottom :: %{Location.t() => Color.t()}

  @type t :: %__MODULE__{
          width: pos_integer(),
          height: pos_integer(),
          bottom: bottom()
        }

  @doc """
  Creates a new board with minimal validations on its parameters.
  """
  @spec new({width(), height()}, bottom()) ::
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

  @doc """
  Adds a `piece` to the bottom of the `board` at a `location`.
  """
  @spec add_to_bottom(t(), Piece.t(), Location.t()) :: t()
  def add_to_bottom(%Board{} = board, %Piece{} = piece, %Location{} = location) do
    piece_as_bottom = Piece.to_bottom(piece, location)
    new_bottom = Map.merge(board.bottom, piece_as_bottom)
    %{board | bottom: new_bottom}
  end

  @doc """
  Checks if the `location` collides with the border or the bottom of the `board`.
  """
  @spec collides?(t(), Location.t()) :: boolean()
  def collides?(%Board{} = board, %Location{} = location) do
    collides_border?(board, location) or location in Map.keys(board.bottom)
  end

  defp collides_border?(board, %Location{} = location) do
    location.col not in 1..board.width or location.row not in 1..board.height
  end

  defp valid_width(width) when is_integer(width) and width > 0, do: :ok
  defp valid_width(width), do: {:error, {:invalid_width, width}}

  defp valid_height(height) when is_integer(height) and height > 0, do: :ok
  defp valid_height(height), do: {:error, {:invalid_height, height}}

  defp valid_bottom(bottom) when is_map(bottom), do: :ok
  defp valid_bottom(bottom), do: {:error, {:invalid_bottom, bottom}}
end

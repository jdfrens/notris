defmodule Notris.PropertyTestGenerators do
  @moduledoc """
  Generators from property tests.
  """

  import StreamData

  alias Notris.{Board, Bottom, Color, Location, Piece, Rotation, Shape}

  # important limits when placing and moving an O shape
  @width_of_o 2
  @height_of_o 2

  @spec empty_board :: StreamData.t(Board.t())
  def empty_board do
    bind(positive_integer(), fn width ->
      bind(positive_integer(), fn height ->
        {:ok, board} = Board.new({width + 5, height + 10})
        constant(board)
      end)
    end)
  end

  @spec board :: StreamData.t(Board.t())
  def board do
    tuple({integer(10..100), integer(10..100)})
    |> bind(fn {width, height} ->
      bind(bottom(width, height), fn bottom ->
        {:ok, board} = Board.new({width + 5, height + 5}, bottom)
        constant(board)
      end)
    end)
  end

  @spec bottom(pos_integer(), pos_integer()) :: StreamData.t(Bottom.t())
  def bottom(width, height) do
    map_of(location(width, height), color())
  end

  @doc """
  Fills the lowest `num_rows` rows of a `Notris.Bottom` leaving the first column empty (so that the rows are not
  eliminated).
  """
  @spec fill_bottom(Board.t(), non_neg_integer()) :: Board.t()
  def fill_bottom(board, num_rows) do
    %Board{width: width, height: height} = board

    bottom =
      for col <- 2..width, row <- (height - num_rows + 1)..height, into: %{} do
        {Location.new(col, row), Enum.random(Color.values())}
      end

    %{board | bottom: bottom}
  end

  @spec col_in(Board.t()) :: StreamData.t(integer())
  def col_in(%Board{width: width} = _board) do
    integer(1..width)
  end

  @spec row_in(Board.t()) :: StreamData.t(integer())
  def row_in(%Board{height: height} = _board) do
    integer(1..height)
  end

  @doc """
  Generates a valid color.
  """
  @spec color :: StreamData.t(Color.t())
  def color do
    member_of(Color.values())
  end

  @doc """
  Generates a location.
  """
  @spec location :: StreamData.t(Location.t())
  def location do
    tuple({positive_integer(), positive_integer()})
    |> bind(fn {col, row} -> constant(Location.new(col, row)) end)
  end

  @doc """
  Generates a valid location on a board.
  """
  @spec location(pos_integer(), pos_integer()) :: StreamData.t(Location.t())
  def location(width, height) do
    tuple({integer(1..width), integer(1..height)})
    |> bind(fn {col, row} -> constant(Location.new(col, row)) end)
  end

  @doc """
  Generates a valid location for a particular shape.
  """
  @spec location_for(Piece.t(), pos_integer(), pos_integer()) :: StreamData.t(Location.t())
  def location_for(%Piece{shape: :o}, width, height) do
    last_col = width - @width_of_o
    last_row = height - @height_of_o

    tuple({integer(1..last_col), integer(1..last_row)})
    |> bind(fn {col, row} -> constant(Location.new(col, row)) end)
  end

  @doc """
  Generates 0, 1, 2, or 3, the number of right rotations to apply.
  """
  @spec rotation :: StreamData.t(Rotation.t())
  def rotation do
    member_of(Rotation.values())
  end

  @doc """
  Generates a valid shape atom.
  """
  @spec shape :: StreamData.t(Shape.t())
  def shape do
    member_of(Shape.values())
  end

  @doc """
  Generates a `Notris.Piece.t()`.
  """
  @spec piece :: StreamData.t(Piece.t())
  def piece do
    bind(tuple({shape(), rotation(), color()}), fn {shape, rotate, color} ->
      {:ok, piece} = Piece.new(shape, rotate, color)
      constant(piece)
    end)
  end
end

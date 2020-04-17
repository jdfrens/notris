defmodule Notris.PropertyTestGenerators do
  @moduledoc """
  Generators from property tests.
  """

  use PropCheck

  alias Notris.{Board, Color, Piece, Rotation, Shape}

  @spec empty_board :: PropCheck.BasicTypes.type()
  def empty_board do
    let {width, height} <- {pos_integer(), pos_integer()} do
      {:ok, board} = Board.new({width + 5, height + 10})
      board
    end
  end

  @spec board :: PropCheck.BasicTypes.type()
  def board do
    let {width, height} <- {pos_integer(), pos_integer()} do
      let board_points <- board_points(width, height) do
        {:ok, board} = Board.new({width + 5, height + 5}, board_points)
        board
      end
    end
  end

  @spec board_points(pos_integer(), pos_integer()) :: PropCheck.BasicTypes.type()
  def board_points(width, height) do
    let locations_and_colors <- list({location(width, height), color()}) do
      Enum.into(locations_and_colors, %{})
    end
  end

  @spec col_in(Board.t()) :: PropCheck.BasicTypes.type()
  def col_in(%Board{width: width} = _board) do
    choose(1, width)
  end

  @spec row_in(Board.t()) :: PropCheck.BasicTypes.type()
  def row_in(%Board{height: height} = _board) do
    choose(1, height)
  end

  @doc """
  Generates a valid color.
  """
  @spec color :: PropCheck.BasicTypes.type()
  def color do
    oneof(Color.values())
  end

  @doc """
  Generates a location.
  """
  @spec location :: PropCheck.BasicTypes.type()
  def location do
    let {col, row} <- {pos_integer(), pos_integer()} do
      {col, row}
    end
  end

  @doc """
  Generates a valid location on a board.
  """
  @spec location(pos_integer(), pos_integer()) :: PropCheck.BasicTypes.type()
  def location(width, height) do
    let {col, row} <- {choose(1, width), choose(1, height)} do
      {col, row}
    end
  end

  @doc """
  Generates valid locations on a board.
  """
  @spec locations(pos_integer(), pos_integer()) :: PropCheck.BasicTypes.type()
  def locations(width, height) do
    list(location(width, height))
  end

  @doc """
  Generates 0, 1, 2, or 3, the number of right rotations to apply.
  """
  @spec rotation :: PropCheck.BasicTypes.type()
  def rotation do
    oneof(Rotation.values())
  end

  @doc """
  Generates a valid shape atom.
  """
  @spec shape :: PropCheck.BasicTypes.type()
  def shape do
    oneof(Shape.values())
  end

  @doc """
  Generates a `Notris.Piece.t()`.
  """
  @spec piece :: PropCheck.BasicTypes.type()
  def piece do
    let {shape, rotate, color} <- {shape(), rotation(), color()} do
      {:ok, piece} = Piece.new(shape, rotate, color)
      piece
    end
  end
end

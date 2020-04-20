defmodule Notris.PropertyTestGenerators do
  @moduledoc """
  Generators from property tests.
  """

  use PropCheck

  alias Notris.{Board, Color, Location, Piece, Rotation, Shape}

  @type pc_type :: PropCheck.BasicTypes.type()

  # important limits when placing and moving an O shape
  @width_of_o 2
  @height_of_o 2

  @spec empty_board :: pc_type()
  def empty_board do
    let {width, height} <- {pos_integer(), pos_integer()} do
      {:ok, board} = Board.new({width + 5, height + 10})
      board
    end
  end

  @spec board :: pc_type()
  def board do
    let {width, height} <- {pos_integer(), pos_integer()} do
      let bottom <- bottom(width, height) do
        {:ok, board} = Board.new({width + 5, height + 5}, bottom)
        board
      end
    end
  end

  @spec bottom(pos_integer(), pos_integer()) :: pc_type()
  def bottom(width, height) do
    let locations_and_colors <- list({location(width, height), color()}) do
      Enum.into(locations_and_colors, %{})
    end
  end

  @spec col_in(Board.t()) :: pc_type()
  def col_in(%Board{width: width} = _board) do
    choose(1, width)
  end

  @spec row_in(Board.t()) :: pc_type()
  def row_in(%Board{height: height} = _board) do
    choose(1, height)
  end

  @doc """
  Generates a valid color.
  """
  @spec color :: pc_type()
  def color do
    oneof(Color.values())
  end

  @doc """
  Generates a location.
  """
  @spec location :: pc_type()
  def location do
    let {col, row} <- {pos_integer(), pos_integer()} do
      Location.new(col, row)
    end
  end

  @doc """
  Generates a valid location on a board.
  """
  @spec location(pos_integer(), pos_integer()) :: pc_type()
  def location(width, height) do
    let {col, row} <- {choose(1, width), choose(1, height)} do
      Location.new(col, row)
    end
  end

  @doc """
  Generates a valid location for a particular shape.
  """
  @spec location_for(Piece.t(), pos_integer(), pos_integer()) :: pc_type()
  def location_for(%Piece{shape: :o}, width, height) do
    last_col = width - @width_of_o
    last_row = height - @height_of_o

    let {col, row} <- {choose(1, last_col), choose(1, last_row)} do
      Location.new(col, row)
    end
  end

  @doc """
  Generates valid locations on a board.
  """
  @spec locations(pos_integer(), pos_integer()) :: pc_type()
  def locations(width, height) do
    list(location(width, height))
  end

  @doc """
  Generates 0, 1, 2, or 3, the number of right rotations to apply.
  """
  @spec rotation :: pc_type()
  def rotation do
    oneof(Rotation.values())
  end

  @doc """
  Generates a valid shape atom.
  """
  @spec shape :: pc_type()
  def shape do
    oneof(Shape.values())
  end

  @doc """
  Generates a `Notris.Piece.t()`.
  """
  @spec piece :: pc_type()
  def piece do
    let {shape, rotate, color} <- {shape(), rotation(), color()} do
      {:ok, piece} = Piece.new(shape, rotate, color)
      piece
    end
  end
end

defmodule Notris.Piece do
  @moduledoc """
  A `Notris.Piece` is the thing that falls that the user gets to control.
  """

  @enforce_keys ~w(shape location points color)a
  defstruct ~w(shape location points color)a

  @type location :: {pos_integer(), pos_integer()}
  @type point :: {pos_integer(), pos_integer()}
  @type points :: list(point())
  @type color :: atom()
  @type shape :: atom()
  @type rotation_integer :: integer()
  @type t :: %__MODULE__{
          shape: shape(),
          location: location(),
          points: points(),
          color: color()
        }

  @type description :: {shape(), boolean(), rotation_integer()}

  @point_grids %{
    i: [{2, 1}, {2, 2}, {2, 3}, {2, 4}],
    l: [{2, 1}, {2, 2}, {2, 3}, {3, 3}],
    o: [{1, 1}, {2, 1}, {1, 2}, {2, 2}],
    t: [{2, 1}, {2, 2}, {2, 3}, {3, 2}],
    z: [{1, 1}, {2, 1}, {2, 2}, {3, 2}]
  }

  @spec new(shape(), boolean(), rotation_integer(), color()) :: t()
  def new(shape, _mirror, rotate, color) do
    points =
      @point_grids[shape]
      |> Stream.iterate(fn points -> Enum.map(points, &rotate_point_right(shape, &1)) end)
      |> Stream.drop(rotate)
      |> Enum.take(1)
      |> List.first()

    %__MODULE__{
      shape: shape,
      location: {4, 4},
      points: points,
      color: color
    }
  end

  @spec rotate_right(t()) :: t()
  def rotate_right(piece) do
    rotated_points = Enum.map(piece.points, &rotate_point_right(piece.shape, &1))
    %{piece | points: rotated_points}
  end

  @spec rotate_left(t()) :: t()
  def rotate_left(piece) do
    rotated_points = Enum.map(piece.points, &rotate_point_left(piece.shape, &1))
    %{piece | points: rotated_points}
  end

  def to_glyph(piece) do
    for row <- 1..4 do
      for col <- 1..4 do
        if {col, row} in piece.points, do: "X", else: "_"
      end
      |> Enum.join()
      |> Kernel.<>("\n")
    end
    |> Enum.join()
  end

  defp rotate_point_right(shape, {col, row}) do
    {grid_size(shape) + 1 - row, col}
  end

  defp rotate_point_left(shape, {col, row}) do
    {row, grid_size(shape) + 1 - col}
  end

  defp grid_size(:i), do: 4
  defp grid_size(:o), do: 2
  defp grid_size(_shape), do: 3
end

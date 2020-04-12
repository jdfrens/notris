defmodule Notris.Piece do
  @moduledoc """
  A `Notris.Piece` is the thing that falls that the user gets to control.
  """

  alias Notris.{Color, Point, Rotation, Shape}

  @enforce_keys ~w(shape location points color)a
  defstruct ~w(shape location points color)a

  @type t :: %__MODULE__{
          shape: Shape.t(),
          location: Point.game_point(),
          points: list(Point.piece_point()),
          color: Color.t()
        }

  @point_grids %{
    i: [{2, 1}, {2, 2}, {2, 3}, {2, 4}],
    l: [{2, 1}, {2, 2}, {2, 3}, {3, 3}],
    ml: [{2, 1}, {2, 2}, {2, 3}, {1, 3}],
    o: [{1, 1}, {2, 1}, {1, 2}, {2, 2}],
    s: [{2, 1}, {3, 1}, {1, 2}, {2, 2}],
    t: [{2, 1}, {2, 2}, {2, 3}, {3, 2}],
    z: [{1, 1}, {2, 1}, {2, 2}, {3, 2}]
  }

    points =
      points_for(shape)
  @spec new(Shape.t(), Rotation.t(), Color.t()) :: {:ok, t()}
  def new(shape, rotation, color) do
        |> rotate_new_points(shape, rotation)

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

  @spec to_glyph(t()) :: String.t()
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

  defp points_for(shape) do
    @point_grids[shape]
  end

  defp rotate_new_points(points, shape, rotate) do
    points
    |> Stream.iterate(fn points -> Enum.map(points, &rotate_point_right(shape, &1)) end)
    |> Stream.drop(rotate)
    |> Enum.take(1)
    |> List.first()
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

defmodule Notris.Piece do
  @moduledoc """
  A `Notris.Piece` is the thing that falls that the user gets to control.
  """

  alias Notris.{Bottom, Color, Location, Offset, Rotation, Shape}

  @enforce_keys ~w(shape offsets color)a
  defstruct ~w(shape offsets color)a

  @type t :: %__MODULE__{
          shape: Shape.t(),
          offsets: list(Offset.t()),
          color: Color.t()
        }

  @shape_offsets %{
    i: [{2, 1}, {2, 2}, {2, 3}, {2, 4}] |> Offset.to_offsets(),
    l: [{2, 1}, {2, 2}, {2, 3}, {3, 3}] |> Offset.to_offsets(),
    ml: [{2, 1}, {2, 2}, {2, 3}, {1, 3}] |> Offset.to_offsets(),
    o: [{1, 1}, {2, 1}, {1, 2}, {2, 2}] |> Offset.to_offsets(),
    s: [{2, 1}, {3, 1}, {1, 2}, {2, 2}] |> Offset.to_offsets(),
    t: [{2, 1}, {2, 2}, {2, 3}, {3, 2}] |> Offset.to_offsets(),
    z: [{1, 1}, {2, 1}, {2, 2}, {3, 2}] |> Offset.to_offsets()
  }

  @spec new(Shape.t(), Rotation.t(), Color.t()) :: {:ok, t()}
  def new(shape, rotation, color) do
    with :ok <- Shape.valid?(shape),
         :ok <- Rotation.valid?(rotation),
         :ok <- Color.valid?(color) do
      offsets =
        offsets_for(shape)
        |> rotate_new_offsets(shape, rotation)

      piece = %__MODULE__{
        shape: shape,
        offsets: offsets,
        color: color
      }

      {:ok, piece}
    end
  end

  @spec to_bottom(t(), Location.t()) :: Bottom.t()
  def to_bottom(piece, %Location{} = location) do
    piece
    |> locations_at(location)
    |> Enum.into(%{}, &{&1, piece.color})
  end

  @spec locations_at(t(), Location.t()) :: list(Location.t())
  def locations_at(piece, %Location{} = location) do
    Enum.map(piece.offsets, &Location.offset(location, &1))
  end

  @spec rotate_right(t()) :: t()
  def rotate_right(piece) do
    rotated_offsets = Enum.map(piece.offsets, &rotate_offset_right(piece.shape, &1))
    %{piece | offsets: rotated_offsets}
  end

  @spec rotate_left(t()) :: t()
  def rotate_left(piece) do
    rotated_offsets = Enum.map(piece.offsets, &rotate_offset_left(piece.shape, &1))
    %{piece | offsets: rotated_offsets}
  end

  @spec to_glyph(t()) :: String.t()
  def to_glyph(piece) do
    for row <- 1..4 do
      for col <- 1..4 do
        offset = Offset.new(col, row)
        if offset in piece.offsets, do: "X", else: "_"
      end
      |> Enum.join()
      |> Kernel.<>("\n")
    end
    |> Enum.join()
  end

  defp offsets_for(shape) do
    @shape_offsets[shape]
  end

  defp rotate_new_offsets(offsets, shape, rotate) do
    offsets
    |> Stream.iterate(fn os -> Enum.map(os, &rotate_offset_right(shape, &1)) end)
    |> Stream.drop(rotate)
    |> Enum.take(1)
    |> List.first()
  end

  defp rotate_offset_right(shape, %Offset{} = offset) do
    Offset.new(grid_size(shape) + 1 - offset.row, offset.col)
  end

  defp rotate_offset_left(shape, %Offset{} = offset) do
    Offset.new(offset.row, grid_size(shape) + 1 - offset.col)
  end

  defp grid_size(:i), do: 4
  defp grid_size(:o), do: 2
  defp grid_size(_shape), do: 3
end

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
  def new(shape, _mirror, _rotate, color) do
    points = @point_grids[shape]

    %__MODULE__{
      shape: shape,
      location: {4, 4},
      points: points,
      color: color
    }
  end
end

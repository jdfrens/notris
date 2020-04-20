defmodule Notris.Location do
  @moduledoc """
  Model for a location.

  A `Location` is the placements of a `Piece` in a `Game`.  The `Piece` provides offsets from a `Location` for the
  actual components of the `Piece` in the `Board`.
  """

  alias Notris.Offset

  @enforce_keys ~w(col row)a
  defstruct [:col, :row]

  @type t :: %__MODULE__{col: integer(), row: integer()}

  @spec new(integer(), integer()) :: t()
  def new(col, row) when is_integer(col) and is_integer(row) do
    %__MODULE__{col: col, row: row}
  end

  @spec offset(t(), Offset.t()) :: t()
  def offset(%__MODULE__{} = location, %Offset{} = offset) do
    new(location.col + offset.col, location.row + offset.row)
  end

  def to_locations(location_tuples) do
    Enum.map(location_tuples, fn {col, row} -> new(col, row) end)
  end
end

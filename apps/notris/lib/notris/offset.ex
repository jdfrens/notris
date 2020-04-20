defmodule Notris.Offset do
  @moduledoc """
  Definitions for offsets, to define the blocks that form the shape of a `Piece`.
  """

  @enforce_keys ~w(col row)a
  defstruct [:col, :row]

  @type t :: %__MODULE__{col: 1..4, row: 1..4}

  @spec new(-1..4, -1..4) :: t()
  def new(col, row) do
    %__MODULE__{col: col, row: row}
  end

  @spec to_offsets(Enumerable.t()) :: Enumerable.t()
  def to_offsets(enum) do
    Enum.map(enum, fn {col, row} -> new(col, row) end)
  end
end

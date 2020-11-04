defmodule Notris.Rotation do
  @moduledoc """
  Definitions for the number of rotations for a new `Notris.Piece`.
  """

  @type t :: 0..3

  @values [0, 1, 2, 3]

  @spec values :: list(non_neg_integer())
  def values do
    @values
  end

  @spec valid?(integer()) :: :ok | {:error, {:bad_rotation, integer()}}
  def valid?(rotations) when rotations in @values, do: :ok
  def valid?(rotations), do: {:error, {:bad_rotation, rotations}}
end

defmodule Notris.Shape do
  @moduledoc """
  Definitions for shapes of `Notris.Piece`s.
  """

  @type t :: :i | :l | :ml | :o | :s | :t | :z

  @values ~w(i l ml o s t z)a

  @spec values :: list(t())
  def values, do: @values

  @spec valid?(atom()) :: :ok | {:error, {:bad_shape, atom()}}
  def valid?(shape) when shape in @values, do: :ok
  def valid?(shape), do: {:error, {:bad_shape, shape}}
end

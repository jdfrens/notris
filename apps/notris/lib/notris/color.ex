defmodule Notris.Color do
  @moduledoc """
  Definitions for colors of `Notris.Piece`s.
  """

  @type t :: :red | :green | :blue | :yellow | :orange | :yellow | :pink

  @values ~w(red green blue yellow orange yellow pink)a

  @spec values :: list(t())
  def values, do: @values

  @spec valid?(atom()) :: :ok | {:error, {:bad_color, t()}}
  def valid?(color) when color in @values, do: :ok
  def valid?(color), do: {:error, {:bad_color, color}}
end

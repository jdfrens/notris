defmodule Notris.Color do
  @moduledoc """
  Definitions for colors of `Notris.Piece`s.
  """

  alias Notris.Shape

  @type t :: :red | :green | :blue | :yellow | :orange | :purple | :grey

  @shape_color_map %{
    i: :red,
    l: :green,
    ml: :blue,
    o: :yellow,
    s: :orange,
    t: :purple,
    z: :grey
  }

  @values Map.values(@shape_color_map)

  @spec values :: list(t())
  def values, do: @values

  @spec valid?(atom()) :: :ok | {:error, {:bad_color, t()}}
  def valid?(color) when color in @values, do: :ok
  def valid?(color), do: {:error, {:bad_color, color}}

  @spec color_of(Shape.t()) :: t()
  def color_of(shape) do
    @shape_color_map[shape]
  end
end

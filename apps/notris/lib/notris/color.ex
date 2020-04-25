defmodule Notris.Color do
  @moduledoc """
  Definitions for colors of `Notris.Piece`s.
  """

  alias Notris.Shape

  @type t :: :red | :green | :blue | :yellow | :orange | :purple | :grey

  @type hexcode :: String.t()

  @shape_color_map %{
    i: :red,
    l: :green,
    ml: :blue,
    o: :yellow,
    s: :orange,
    t: :purple,
    z: :grey
  }

  # https://htmlcolorcodes.com/color-chart/
  @hexcodes %{
    red: {"#CE351B", "#A50C00"},
    green: {"#34B515", "#34B515"},
    blue: {"#049CBF", "#047BA0"},
    yellow: {"#F9E79F", "#D4AC0D"},
    orange: {"#D66203", "#EF880C"},
    purple: {"#835EA5", "#683C96"},
    grey: {"#CCD1D1", "#707B7C"}
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

  @spec hexcodes_of(t()) :: hexcode()
  def hexcodes_of(color) do
    @hexcodes[color]
  end
end

defmodule NotrisWeb.NotrisLive.XML do
  @moduledoc """
  Functions for generating XML.
  """

  import XmlBuilder

  alias NotrisWeb.NotrisLive

  @typedoc """
  Type for the XML content generated by `box/3`.
  """
  @type box :: list({:rect | :polyline, map(), nil})

  @doc """
  Renders XML that has been built with `box/2` below.

  The rendered content is HTML safe.
  """
  @spec render(box()) :: {:safe, String.t()}
  def render(xml) do
    xml
    |> generate(format: :none)
    |> Phoenix.HTML.raw()
  end

  @doc """
  Generates internal XML for a "box".  Each Notris piece has four boxes.

  * `x` and `y` are the coordinates in the SVG image (upper-left corner).
  * `length` is the width and height of the box.
  * `primary_color` and `secondary_color` are the colors of the box.
  """
  @spec box(NotrisLive.coords(), NotrisLive.dimension(), NotrisLive.colors()) :: box()
  def box({x, y}, length, {primary_color, secondary_color}) do
    [
      element(:rect, %{
        x: x,
        y: y,
        width: length,
        height: length,
        style: "fill:#{primary_color};"
      }),
      element(:polyline, %{
        points: highlight_polyline_points({x, y}, length),
        style: "fill:#{secondary_color};"
      })
    ]
  end

  @spec border({number(), number()}, String.t()) :: box()
  def border({width, height}, board_color) do
    points =
      [{0, 0}, {0, height}, {width, height}, {width, 0}, {0, 0}]
      |> Enum.map(fn {x, y} -> "#{x},#{y}" end)
      |> Enum.join(" ")

    element(:polyline, %{points: points, style: "fill:#{board_color};"})
  end

  @spec highlight_polyline_points(NotrisLive.coords(), NotrisLive.dimension()) :: String.t()
  defp highlight_polyline_points({x, y}, length) do
    [{x, y}, {x + length, y}, {x + length, y + div(length * 875, 1000)}]
    |> Enum.map(fn {x, y} -> "#{x},#{y}" end)
    |> Enum.join(" ")
  end
end

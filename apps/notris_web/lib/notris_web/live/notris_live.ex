defmodule NotrisWeb.NotrisLive do
  @moduledoc """
  LiveView to play the game of Notris.
  """

  use Phoenix.LiveView

  import XmlBuilder

  @type coords :: {non_neg_integer(), non_neg_integer()}
  @type dimension :: non_neg_integer()
  @type colors :: {String.t(), String.t()}

  def render(assigns) do
    ~L"""
    <div>
      <?xml version="1.0" encoding="iso-8859-1"?>
      <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 496 496" style="enable-background:new 0 0 496 496;" xml:space="preserve">
        <%= render_xml box({300, 0}, 64, {"#CE351B", "#A50C00"}) %>
        <%= render_xml box({300, 64}, 64, {"#CE351B", "#A50C00"}) %>
        <%= render_xml box({300, 64 * 2}, 64, {"#CE351B", "#A50C00"}) %>
        <%= render_xml box({300, 64 * 3}, 64, {"#CE351B", "#A50C00"}) %>
      </svg>

    </div>
    """
  end

  def render_xml(xml) do
    xml
    |> generate(format: :none)
    |> Phoenix.HTML.raw()
  end

  @spec box(coords(), dimension(), colors()) :: [{atom(), any(), any()}]
  def box({x, y}, length, {primary_color, secondary_color}) do
    [
      element(:rect, %{x: x, y: y, width: length, height: length, style: "fill:#{primary_color};"}),
      element(:polyline, %{
        points: highlight_polyline_points({x, y}, length),
        style: "fill:#{secondary_color};"
      })
    ]
  end

  @spec highlight_polyline_points(coords(), dimension()) :: String.t()
  defp highlight_polyline_points({x, y}, length) do
    [{x, y}, {x + length, y}, {x + length, y + div(length * 875, 1000)}]
    |> Enum.map(fn {x, y} -> "#{x},#{y}" end)
    |> Enum.join(" ")
  end
end

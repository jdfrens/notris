defmodule NotrisWeb.NotrisLive.WebColor do
  @moduledoc """
  Defines the actual colors that appear on the web page.
  """

  @type hexcode :: String.t()

  # https://htmlcolorcodes.com/color-chart/
  @hexcodes %{
    red: {"#CE351B", "#A50C00"},
    green: {"#34B515", "#1E8449"},
    blue: {"#049CBF", "#047BA0"},
    yellow: {"#F9E79F", "#D4AC0D"},
    orange: {"#D66203", "#EF880C"},
    purple: {"#835EA5", "#683C96"},
    grey: {"#CCD1D1", "#707B7C"}
  }

  @doc """
  Returns a primary and secondary hexcodes for a Notris color.
  """
  @spec hexcodes_of(Notris.color()) :: hexcode()
  def hexcodes_of(color) do
    @hexcodes[color]
  end
end

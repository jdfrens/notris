defmodule NotrisWeb.NotrisLiveTest do
  use NotrisWeb.ConnCase
  import Phoenix.LiveViewTest

  test "has an SVG", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/notris")
    assert html =~ "</svg>"
  end
end

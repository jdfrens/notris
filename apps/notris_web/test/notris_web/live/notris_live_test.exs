defmodule NotrisWeb.NotrisLiveTest do
  use NotrisWeb.ConnCase
  import Phoenix.LiveViewTest

  alias NotrisWeb.NotrisLive

  test "has an SVG", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/notris")
    assert html =~ "</svg>"
  end

  describe "box/3" do
    test "returns a :rect tuple with attributes" do
      assert [rect, _polyline] = NotrisLive.box({10, 20}, 100, {"#FFFFFF", "#999999"})

      assert rect ==
               {
                 :rect,
                 %{x: 10, y: 20, width: 100, height: 100, style: "fill:#FFFFFF;"},
                 nil
               }
    end

    test "returns a :polyline tuple with attributes" do
      assert [_rect, polyline] = NotrisLive.box({10, 20}, 100, {"#FFFFFF", "#999999"})

      assert {
               :polyline,
               %{points: points, style: "fill:#999999;"},
               nil
             } = polyline

      assert points == "10,20 110,20 110,107"
    end
  end
end

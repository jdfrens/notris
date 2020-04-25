defmodule NotrisWeb.NotrisLive.XMLTest do
  use ExUnit.Case, async: true

  alias NotrisWeb.NotrisLive.XML

  describe "box/3" do
    test "returns a :rect tuple with attributes" do
      assert [rect, _polyline] = XML.box({10, 20}, 100, {"#FFFFFF", "#999999"})

      assert rect ==
               {
                 :rect,
                 %{x: 10, y: 20, width: 100, height: 100, style: "fill:#FFFFFF;"},
                 nil
               }
    end

    test "returns a :polyline tuple with attributes" do
      assert [_rect, polyline] = XML.box({10, 20}, 100, {"#FFFFFF", "#999999"})

      assert {
               :polyline,
               %{points: points, style: "fill:#999999;"},
               nil
             } = polyline

      assert points == "10,20 110,20 110,107"
    end
  end
end

defmodule Notris.ShapeTest do
  use ExUnit.Case, async: true

  alias Notris.{Color, Shape}

  test "same number of shapes and colors" do
    assert length(Shape.values()) == length(Color.values())
  end
end

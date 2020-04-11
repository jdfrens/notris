defmodule Notris.PieceTest do
  use ExUnit.Case, async: true
  use PropCheck
  import Notris.PropCheckHelpers

  alias Notris.Piece

  describe "#new/3" do
    property "uses the color" do
      forall {shape, mirror, rotate, color} <- {shape(), boolean(), rotation(), color()} do
        match?(%Piece{color: ^color}, Piece.new(shape, mirror, rotate, color))
      end
    end

    test "it builds an I" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {2, 4}]} = Piece.new(:i, false, 0, color())
    end

    test "it builds an L" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 3}]} = Piece.new(:l, false, 0, color())
    end

    test "it builds an O" do
      assert %Piece{points: [{1, 1}, {2, 1}, {1, 2}, {2, 2}]} = Piece.new(:o, false, 0, color())
    end

    test "it builds a T" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 2}]} = Piece.new(:t, false, 0, color())
    end

    test "it builds a Z" do
      assert %Piece{points: [{1, 1}, {2, 1}, {2, 2}, {3, 2}]} = Piece.new(:z, false, 0, color())
    end
  end

  describe "#rotate_right/1" do
    test "rotates an I" do
      i = Piece.new(:i, false, 0, color())
      assert [{4, 2}, {3, 2}, {2, 2}, {1, 2}] = Piece.rotate_right(i).points
    end

    test "rotates an L" do
      l = Piece.new(:l, false, 0, color())
      assert [{3, 2}, {2, 2}, {1, 2}, {1, 3}] = Piece.rotate_right(l).points
    end

    test "rotates an O" do
      o = Piece.new(:o, false, 0, color())
      assert [{2, 1}, {2, 2}, {1, 1}, {1, 2}] = Piece.rotate_right(o).points
    end

    test "rotates a T" do
      t = Piece.new(:t, false, 0, color())
      assert [{3, 2}, {2, 2}, {1, 2}, {2, 3}] = Piece.rotate_right(t).points
    end

    test "rotates a Z" do
      z = Piece.new(:z, false, 0, color())
      assert [{3, 1}, {3, 2}, {2, 2}, {2, 3}] = Piece.rotate_right(z).points
    end
  end

  describe "#to_glyph" do
    test "I" do
      piece = Piece.new(:i, false, 0, color())

      assert Piece.to_glyph(piece) == """
             _X__
             _X__
             _X__
             _X__
             """
    end
  end
end

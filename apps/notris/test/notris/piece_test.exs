defmodule Notris.PieceTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias Notris.PropertyTestGenerators, as: G

  alias Notris.Piece

  describe "#new/3" do
    property "uses the color" do
      forall {shape, rotate, color} <- {G.shape(), G.rotation(), G.color()} do
        match?(%Piece{color: ^color}, Piece.new(shape, rotate, color))
      end
    end

    test "it builds an I" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {2, 4}]} = Piece.new(:i, 0, G.color())
    end

    test "it builds an L" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 3}]} = Piece.new(:l, 0, G.color())
    end

    test "it builds a mirror L" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {1, 3}]} = Piece.new(:ml, 0, G.color())
    end

    test "it builds an O" do
      assert %Piece{points: [{1, 1}, {2, 1}, {1, 2}, {2, 2}]} = Piece.new(:o, 0, G.color())
    end

    test "it builds an S" do
      assert %Piece{points: [{2, 1}, {3, 1}, {1, 2}, {2, 2}]} = Piece.new(:s, 0, G.color())
    end

    test "it builds a T" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 2}]} = Piece.new(:t, 0, G.color())
    end

    test "it builds a Z" do
      assert %Piece{points: [{1, 1}, {2, 1}, {2, 2}, {3, 2}]} = Piece.new(:z, 0, G.color())
    end

    test "it rotates to the right n times" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 2}]} = Piece.new(:t, 0, G.color())
      assert %Piece{points: [{3, 2}, {2, 2}, {1, 2}, {2, 3}]} = Piece.new(:t, 1, G.color())
      assert %Piece{points: [{2, 3}, {2, 2}, {2, 1}, {1, 2}]} = Piece.new(:t, 2, G.color())
      assert %Piece{points: [{1, 2}, {2, 2}, {3, 2}, {2, 1}]} = Piece.new(:t, 3, G.color())
    end
  end

  describe "#rotate_right/1" do
    test "rotates an I" do
      i = Piece.new(:i, 0, G.color())
      assert [{4, 2}, {3, 2}, {2, 2}, {1, 2}] = Piece.rotate_right(i).points
    end

    test "rotates an L" do
      l = Piece.new(:l, 0, G.color())
      assert [{3, 2}, {2, 2}, {1, 2}, {1, 3}] = Piece.rotate_right(l).points
    end

    test "rotates a mirror L" do
      ml = Piece.new(:ml, 0, G.color())
      assert [{3, 2}, {2, 2}, {1, 2}, {1, 1}] = Piece.rotate_right(ml).points
    end

    test "rotates an O" do
      o = Piece.new(:o, 0, G.color())
      assert [{2, 1}, {2, 2}, {1, 1}, {1, 2}] = Piece.rotate_right(o).points
    end

    test "rotates an S" do
      z = Piece.new(:s, 0, G.color())
      assert [{3, 2}, {3, 3}, {2, 1}, {2, 2}] = Piece.rotate_right(z).points
    end

    test "rotates a T" do
      t = Piece.new(:t, 0, G.color())
      assert [{3, 2}, {2, 2}, {1, 2}, {2, 3}] = Piece.rotate_right(t).points
    end

    test "rotates a Z" do
      z = Piece.new(:z, 0, G.color())
      assert [{3, 1}, {3, 2}, {2, 2}, {2, 3}] = Piece.rotate_right(z).points
    end
  end

  describe "#rotate_left/1" do
    test "rotates an I" do
      i = Piece.new(:i, 0, G.color())
      assert [{1, 3}, {2, 3}, {3, 3}, {4, 3}] = Piece.rotate_left(i).points
    end

    test "rotates an L" do
      l = Piece.new(:l, 0, G.color())
      assert [{1, 2}, {2, 2}, {3, 2}, {3, 1}] = Piece.rotate_left(l).points
    end

    test "rotates a mirror L" do
      ml = Piece.new(:ml, 0, G.color())
      assert [{1, 2}, {2, 2}, {3, 2}, {3, 3}] = Piece.rotate_left(ml).points
    end

    test "rotates an O" do
      o = Piece.new(:o, 0, G.color())
      assert [{1, 2}, {1, 1}, {2, 2}, {2, 1}] = Piece.rotate_left(o).points
    end

    test "rotates an S" do
      s = Piece.new(:s, 0, G.color())
      assert [{1, 2}, {1, 1}, {2, 3}, {2, 2}] = Piece.rotate_left(s).points
    end

    test "rotates a T" do
      t = Piece.new(:t, 0, G.color())
      assert [{1, 2}, {2, 2}, {3, 2}, {2, 1}] = Piece.rotate_left(t).points
    end

    test "rotates a Z" do
      z = Piece.new(:z, 0, G.color())
      assert [{1, 3}, {1, 2}, {2, 2}, {2, 1}] = Piece.rotate_left(z).points
    end
  end

  describe "#to_glyph" do
    test "I" do
      piece = Piece.new(:i, 0, G.color())

      assert Piece.to_glyph(piece) == """
             _X__
             _X__
             _X__
             _X__
             """
    end
  end
end

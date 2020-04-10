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
      assert %Piece{points: [{2, 2}, {2, 3}, {3, 2}, {3, 3}]} = Piece.new(:o, false, 0, color())
    end

    test "it builds a T" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 2}]} = Piece.new(:t, false, 0, color())
    end

    test "it builds a Z" do
      assert %Piece{points: [{1, 2}, {2, 2}, {2, 3}, {3, 3}]} = Piece.new(:z, false, 0, color())
    end
  end
end

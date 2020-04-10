defmodule Notris.PieceTest do
  use ExUnit.Case, async: true

  alias Notris.Piece

  describe "#new/3" do
    test "it builds an I" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {2, 4}]} = Piece.new(:i, false, 0, :yellow)
    end

    test "it builds an L" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 3}]} = Piece.new(:l, false, 0, :yellow)
    end

    test "it builds an O" do
      assert %Piece{points: [{2, 2}, {2, 3}, {3, 2}, {3, 3}]} = Piece.new(:o, false, 0, :yellow)
    end

    test "it builds a T" do
      assert %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 2}]} = Piece.new(:t, false, 0, :yellow)
    end

    test "it builds a Z" do
      assert %Piece{points: [{1, 2}, {2, 2}, {2, 3}, {3, 3}]} = Piece.new(:z, false, 0, :yellow)
    end
  end
end

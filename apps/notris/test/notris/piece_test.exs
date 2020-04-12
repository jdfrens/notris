defmodule Notris.PieceTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias Notris.PropertyTestGenerators, as: G

  alias Notris.{Color, Piece, Rotation, Shape}

  setup do
    some_color = Enum.random(Color.values())

    {:ok, some_color: some_color}
  end

  describe "#new/3 validations" do
    property "validates the shape" do
      bad_shape = such_that s <- atom(), when: s not in Shape.values()

      forall {shape, rotate, color} <- {bad_shape, G.rotation(), G.color()} do
        match?({:error, {:bad_shape, ^shape}}, Piece.new(shape, rotate, color))
      end
    end

    property "validates the color" do
      bad_color = such_that c <- atom(), when: c not in Color.values()

      forall {shape, rotate, color} <- {G.shape(), G.rotation(), bad_color} do
        match?({:error, {:bad_color, ^color}}, Piece.new(shape, rotate, color))
      end
    end

    property "validates the rotation" do
      bad_rotation = such_that r <- integer(), when: r not in Rotation.values()

      forall {shape, rotation, color} <- {G.shape(), bad_rotation, G.color()} do
        match?({:error, {:bad_rotation, ^rotation}}, Piece.new(shape, rotation, color))
      end
    end
  end

  describe "#new/3" do
    property "uses the color" do
      forall {shape, rotation, color} <- {G.shape(), G.rotation(), G.color()} do
        match?({:ok, %Piece{color: ^color}}, Piece.new(shape, rotation, color))
      end
    end

    test "it builds an I", %{some_color: some_color} do
      assert {:ok, %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {2, 4}]}} =
               Piece.new(:i, 0, some_color)
    end

    test "it builds an L", %{some_color: some_color} do
      assert {:ok, %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 3}]}} =
               Piece.new(:l, 0, some_color)
    end

    test "it builds a mirror L", %{some_color: some_color} do
      assert {:ok, %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {1, 3}]}} =
               Piece.new(:ml, 0, some_color)
    end

    test "it builds an O", %{some_color: some_color} do
      assert {:ok, %Piece{points: [{1, 1}, {2, 1}, {1, 2}, {2, 2}]}} =
               Piece.new(:o, 0, some_color)
    end

    test "it builds an S", %{some_color: some_color} do
      assert {:ok, %Piece{points: [{2, 1}, {3, 1}, {1, 2}, {2, 2}]}} =
               Piece.new(:s, 0, some_color)
    end

    test "it builds a T", %{some_color: some_color} do
      assert {:ok, %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 2}]}} =
               Piece.new(:t, 0, some_color)
    end

    test "it builds a Z", %{some_color: some_color} do
      assert {:ok, %Piece{points: [{1, 1}, {2, 1}, {2, 2}, {3, 2}]}} =
               Piece.new(:z, 0, some_color)
    end

    test "it rotates to the right n times", %{some_color: some_color} do
      assert {:ok, %Piece{points: [{2, 1}, {2, 2}, {2, 3}, {3, 2}]}} =
               Piece.new(:t, 0, some_color)

      assert {:ok, %Piece{points: [{3, 2}, {2, 2}, {1, 2}, {2, 3}]}} =
               Piece.new(:t, 1, some_color)

      assert {:ok, %Piece{points: [{2, 3}, {2, 2}, {2, 1}, {1, 2}]}} =
               Piece.new(:t, 2, some_color)

      assert {:ok, %Piece{points: [{1, 2}, {2, 2}, {3, 2}, {2, 1}]}} =
               Piece.new(:t, 3, some_color)
    end
  end

  describe "#rotate_right/1" do
    test "rotates an I", %{some_color: some_color} do
      {:ok, i} = Piece.new(:i, 0, some_color)
      assert [{4, 2}, {3, 2}, {2, 2}, {1, 2}] = Piece.rotate_right(i).points
    end

    test "rotates an L", %{some_color: some_color} do
      {:ok, l} = Piece.new(:l, 0, some_color)
      assert [{3, 2}, {2, 2}, {1, 2}, {1, 3}] = Piece.rotate_right(l).points
    end

    test "rotates a mirror L", %{some_color: some_color} do
      {:ok, ml} = Piece.new(:ml, 0, some_color)
      assert [{3, 2}, {2, 2}, {1, 2}, {1, 1}] = Piece.rotate_right(ml).points
    end

    test "rotates an O", %{some_color: some_color} do
      {:ok, o} = Piece.new(:o, 0, some_color)
      assert [{2, 1}, {2, 2}, {1, 1}, {1, 2}] = Piece.rotate_right(o).points
    end

    test "rotates an S", %{some_color: some_color} do
      {:ok, s} = Piece.new(:s, 0, some_color)
      assert [{3, 2}, {3, 3}, {2, 1}, {2, 2}] = Piece.rotate_right(s).points
    end

    test "rotates a T", %{some_color: some_color} do
      {:ok, t} = Piece.new(:t, 0, some_color)
      assert [{3, 2}, {2, 2}, {1, 2}, {2, 3}] = Piece.rotate_right(t).points
    end

    test "rotates a Z", %{some_color: some_color} do
      {:ok, z} = Piece.new(:z, 0, some_color)
      assert [{3, 1}, {3, 2}, {2, 2}, {2, 3}] = Piece.rotate_right(z).points
    end
  end

  describe "#rotate_left/1" do
    test "rotates an I", %{some_color: some_color} do
      {:ok, i} = Piece.new(:i, 0, some_color)
      assert [{1, 3}, {2, 3}, {3, 3}, {4, 3}] = Piece.rotate_left(i).points
    end

    test "rotates an L", %{some_color: some_color} do
      {:ok, l} = Piece.new(:l, 0, some_color)
      assert [{1, 2}, {2, 2}, {3, 2}, {3, 1}] = Piece.rotate_left(l).points
    end

    test "rotates a mirror L", %{some_color: some_color} do
      {:ok, ml} = Piece.new(:ml, 0, some_color)
      assert [{1, 2}, {2, 2}, {3, 2}, {3, 3}] = Piece.rotate_left(ml).points
    end

    test "rotates an O", %{some_color: some_color} do
      {:ok, o} = Piece.new(:o, 0, some_color)
      assert [{1, 2}, {1, 1}, {2, 2}, {2, 1}] = Piece.rotate_left(o).points
    end

    test "rotates an S", %{some_color: some_color} do
      {:ok, s} = Piece.new(:s, 0, some_color)
      assert [{1, 2}, {1, 1}, {2, 3}, {2, 2}] = Piece.rotate_left(s).points
    end

    test "rotates a T", %{some_color: some_color} do
      {:ok, t} = Piece.new(:t, 0, some_color)
      assert [{1, 2}, {2, 2}, {3, 2}, {2, 1}] = Piece.rotate_left(t).points
    end

    test "rotates a Z", %{some_color: some_color} do
      {:ok, z} = Piece.new(:z, 0, some_color)
      assert [{1, 3}, {1, 2}, {2, 2}, {2, 1}] = Piece.rotate_left(z).points
    end
  end

  describe "#to_glyph" do
    test "I", %{some_color: some_color} do
      {:ok, piece} = Piece.new(:i, 0, some_color)

      assert Piece.to_glyph(piece) == """
             _X__
             _X__
             _X__
             _X__
             """
    end
  end
end

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

  describe "#board_points_at/1" do
    # test one shape directly
    test "offsets an S", %{some_color: some_color} do
      {:ok, s} = Piece.new(:s, 0, some_color)

      assert Piece.board_points_at(s, {45, 23}) == %{
               {47, 24} => some_color,
               {48, 24} => some_color,
               {46, 25} => some_color,
               {47, 25} => some_color
             }
    end

    property "offsets all of the points in the shape within 4x4 grid" do
      forall {piece, {l_col, l_row} = location} <- {G.piece(), G.location()} do
        board_points = Piece.board_points_at(piece, location)

        Enum.all?(Map.keys(board_points), fn {col, row} ->
          (col - l_col) in 0..4 and (row - l_row) in 0..4
        end)
      end
    end

    property "uses piece color for all points" do
      forall {piece, location} <- {G.piece(), G.location()} do
        board_points = Piece.board_points_at(piece, location)
        board_points |> Map.values() |> Enum.uniq() == [piece.color]
      end
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

  describe "rotate_right/1 and rotate_left/1" do
    property "four right rotations gets back to the original" do
      forall piece <- G.piece() do
        %Piece{} = rotated_piece = rotate_n(piece, &Piece.rotate_right/1, 4)

        rotated_piece.points == piece.points
      end
    end

    property "four left rotations gets back to the original" do
      forall piece <- G.piece() do
        %Piece{} = rotated_piece = rotate_n(piece, &Piece.rotate_left/1, 4)

        rotated_piece.points == piece.points
      end
    end

    property "right n times is same as left 4 - n times" do
      forall {n, piece} <- {choose(0, 4), G.piece()} do
        %Piece{} = right_rotated_piece = rotate_n(piece, &Piece.rotate_right/1, n)
        %Piece{} = left_rotated_piece = rotate_n(piece, &Piece.rotate_left/1, 4 - n)

        right_rotated_piece.points == left_rotated_piece.points
      end
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

  defp rotate_n(piece, fun, n) do
    piece
    |> Stream.iterate(fun)
    |> Stream.drop(n)
    |> Enum.take(1)
    |> List.first()
  end
end

defmodule Notris.PieceTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias Notris.PropertyTestGenerators, as: G

  alias Notris.{Color, Location, Offset, Piece, Rotation, Shape}

  setup do
    some_color = Enum.random(Color.values())

    {:ok, some_color: some_color}
  end

  describe "new/3 validations" do
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

  describe "new/3" do
    property "uses the color" do
      forall {shape, rotation, color} <- {G.shape(), G.rotation(), G.color()} do
        match?({:ok, %Piece{color: ^color}}, Piece.new(shape, rotation, color))
      end
    end

    test "it builds an I", %{some_color: some_color} do
      {:ok, piece} = Piece.new(:i, 0, some_color)
      assert piece.offsets == [{2, 1}, {2, 2}, {2, 3}, {2, 4}] |> Offset.to_offsets()
    end

    test "it builds an L", %{some_color: some_color} do
      {:ok, piece} = Piece.new(:l, 0, some_color)
      assert piece.offsets == [{2, 1}, {2, 2}, {2, 3}, {3, 3}] |> Offset.to_offsets()
    end

    test "it builds a mirror L", %{some_color: some_color} do
      {:ok, piece} = Piece.new(:ml, 0, some_color)
      assert piece.offsets == [{2, 1}, {2, 2}, {2, 3}, {1, 3}] |> Offset.to_offsets()
    end

    test "it builds an O", %{some_color: some_color} do
      {:ok, piece} = Piece.new(:o, 0, some_color)
      assert piece.offsets == [{1, 1}, {2, 1}, {1, 2}, {2, 2}] |> Offset.to_offsets()
    end

    test "it builds an S", %{some_color: some_color} do
      {:ok, piece} = Piece.new(:s, 0, some_color)
      assert piece.offsets == [{2, 1}, {3, 1}, {1, 2}, {2, 2}] |> Offset.to_offsets()
    end

    test "it builds a T", %{some_color: some_color} do
      {:ok, piece} = Piece.new(:t, 0, some_color)
      assert piece.offsets == [{2, 1}, {2, 2}, {2, 3}, {3, 2}] |> Offset.to_offsets()
    end

    test "it builds a Z", %{some_color: some_color} do
      {:ok, piece} = Piece.new(:z, 0, some_color)
      assert piece.offsets == [{1, 1}, {2, 1}, {2, 2}, {3, 2}] |> Offset.to_offsets()
    end

    test "it rotates to the right n times", %{some_color: some_color} do
      {:ok, piece0} = Piece.new(:t, 0, some_color)
      assert piece0.offsets == [{2, 1}, {2, 2}, {2, 3}, {3, 2}] |> Offset.to_offsets()

      {:ok, piece1} = Piece.new(:t, 1, some_color)
      assert piece1.offsets == [{3, 2}, {2, 2}, {1, 2}, {2, 3}] |> Offset.to_offsets()

      {:ok, piece2} = Piece.new(:t, 2, some_color)
      assert piece2.offsets == [{2, 3}, {2, 2}, {2, 1}, {1, 2}] |> Offset.to_offsets()

      {:ok, piece3} = Piece.new(:t, 3, some_color)
      assert piece3.offsets == [{1, 2}, {2, 2}, {3, 2}, {2, 1}] |> Offset.to_offsets()
    end
  end

  describe "to_bottom/1" do
    # test one shape directly
    test "offsets an S", %{some_color: some_color} do
      {:ok, s} = Piece.new(:s, 0, some_color)

      assert Piece.to_bottom(s, Location.new(45, 23)) == %{
               %Location{col: 47, row: 24} => some_color,
               %Location{col: 48, row: 24} => some_color,
               %Location{col: 46, row: 25} => some_color,
               %Location{col: 47, row: 25} => some_color
             }
    end

    property "uses piece color for all locations on the bottom" do
      forall {piece, location} <- {G.piece(), G.location()} do
        bottom = Piece.to_bottom(piece, location)
        bottom |> Map.values() |> Enum.uniq() == [piece.color]
      end
    end
  end

  describe "locations_at/1" do
    # test one shape directly
    test "offsets an S", %{some_color: some_color} do
      {:ok, s} = Piece.new(:s, 0, some_color)

      assert Piece.locations_at(s, Location.new(45, 23)) ==
               [{47, 24}, {48, 24}, {46, 25}, {47, 25}] |> Location.to_locations()
    end

    property "offsets the shape within 4x4 grid" do
      forall {piece, location} <- {G.piece(), G.location()} do
        piece_locations = Piece.locations_at(piece, location)

        Enum.all?(piece_locations, fn %Location{} = pl ->
          (pl.col - location.col) in 1..4 and (pl.row - location.row) in 1..4
        end)
      end
    end
  end

  describe "rotate_right/1" do
    test "rotates an I", %{some_color: some_color} do
      {:ok, i} = Piece.new(:i, 0, some_color)

      assert [{4, 2}, {3, 2}, {2, 2}, {1, 2}] |> Offset.to_offsets() ==
               Piece.rotate_right(i).offsets
    end

    test "rotates an L", %{some_color: some_color} do
      {:ok, l} = Piece.new(:l, 0, some_color)

      assert [{3, 2}, {2, 2}, {1, 2}, {1, 3}] |> Offset.to_offsets() ==
               Piece.rotate_right(l).offsets
    end

    test "rotates a mirror L", %{some_color: some_color} do
      {:ok, ml} = Piece.new(:ml, 0, some_color)

      assert [{3, 2}, {2, 2}, {1, 2}, {1, 1}] |> Offset.to_offsets() ==
               Piece.rotate_right(ml).offsets
    end

    test "rotates an O", %{some_color: some_color} do
      {:ok, o} = Piece.new(:o, 0, some_color)

      assert [{2, 1}, {2, 2}, {1, 1}, {1, 2}] |> Offset.to_offsets() ==
               Piece.rotate_right(o).offsets
    end

    test "rotates an S", %{some_color: some_color} do
      {:ok, s} = Piece.new(:s, 0, some_color)

      assert [{3, 2}, {3, 3}, {2, 1}, {2, 2}] |> Offset.to_offsets() ==
               Piece.rotate_right(s).offsets
    end

    test "rotates a T", %{some_color: some_color} do
      {:ok, t} = Piece.new(:t, 0, some_color)

      assert [{3, 2}, {2, 2}, {1, 2}, {2, 3}] |> Offset.to_offsets() ==
               Piece.rotate_right(t).offsets
    end

    test "rotates a Z", %{some_color: some_color} do
      {:ok, z} = Piece.new(:z, 0, some_color)

      assert [{3, 1}, {3, 2}, {2, 2}, {2, 3}] |> Offset.to_offsets() ==
               Piece.rotate_right(z).offsets
    end
  end

  describe "rotate_left/1" do
    test "rotates an I", %{some_color: some_color} do
      {:ok, i} = Piece.new(:i, 0, some_color)

      assert [{1, 3}, {2, 3}, {3, 3}, {4, 3}] |> Offset.to_offsets() ==
               Piece.rotate_left(i).offsets
    end

    test "rotates an L", %{some_color: some_color} do
      {:ok, l} = Piece.new(:l, 0, some_color)

      assert [{1, 2}, {2, 2}, {3, 2}, {3, 1}] |> Offset.to_offsets() ==
               Piece.rotate_left(l).offsets
    end

    test "rotates a mirror L", %{some_color: some_color} do
      {:ok, ml} = Piece.new(:ml, 0, some_color)

      assert [{1, 2}, {2, 2}, {3, 2}, {3, 3}] |> Offset.to_offsets() ==
               Piece.rotate_left(ml).offsets
    end

    test "rotates an O", %{some_color: some_color} do
      {:ok, o} = Piece.new(:o, 0, some_color)

      assert [{1, 2}, {1, 1}, {2, 2}, {2, 1}] |> Offset.to_offsets() ==
               Piece.rotate_left(o).offsets
    end

    test "rotates an S", %{some_color: some_color} do
      {:ok, s} = Piece.new(:s, 0, some_color)

      assert [{1, 2}, {1, 1}, {2, 3}, {2, 2}] |> Offset.to_offsets() ==
               Piece.rotate_left(s).offsets
    end

    test "rotates a T", %{some_color: some_color} do
      {:ok, t} = Piece.new(:t, 0, some_color)

      assert [{1, 2}, {2, 2}, {3, 2}, {2, 1}] |> Offset.to_offsets() ==
               Piece.rotate_left(t).offsets
    end

    test "rotates a Z", %{some_color: some_color} do
      {:ok, z} = Piece.new(:z, 0, some_color)

      assert [{1, 3}, {1, 2}, {2, 2}, {2, 1}] |> Offset.to_offsets() ==
               Piece.rotate_left(z).offsets
    end
  end

  describe "rotate_right/1 and rotate_left/1" do
    property "four right rotations gets back to the original" do
      forall piece <- G.piece() do
        %Piece{} = rotated_piece = rotate_n(piece, &Piece.rotate_right/1, 4)

        rotated_piece.offsets == piece.offsets
      end
    end

    property "four left rotations gets back to the original" do
      forall piece <- G.piece() do
        %Piece{} = rotated_piece = rotate_n(piece, &Piece.rotate_left/1, 4)

        rotated_piece.offsets == piece.offsets
      end
    end

    property "right n times is same as left 4 - n times" do
      forall {n, piece} <- {choose(0, 4), G.piece()} do
        %Piece{} = right_rotated_piece = rotate_n(piece, &Piece.rotate_right/1, n)
        %Piece{} = left_rotated_piece = rotate_n(piece, &Piece.rotate_left/1, 4 - n)

        right_rotated_piece.offsets == left_rotated_piece.offsets
      end
    end
  end

  describe "to_glyph" do
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

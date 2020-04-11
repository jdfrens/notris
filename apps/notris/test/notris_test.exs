defmodule NotrisTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias Notris.Piece
  alias Notris.PropertyTestGenerators, as: G

  describe "rotate_right/1 and rotate_left/1" do
    property "four right rotations gets back to the original" do
      forall piece <- G.piece() do
        %Piece{} = rotated_piece = rotate_n(piece, &Notris.rotate_right/1, 4)

        rotated_piece.points == piece.points
      end
    end

    property "four left rotations gets back to the original" do
      forall piece <- G.piece() do
        %Piece{} = rotated_piece = rotate_n(piece, &Notris.rotate_left/1, 4)

        rotated_piece.points == piece.points
      end
    end

    property "right n times is same as left 4 - n times" do
      forall {n, piece} <- {choose(0, 4), G.piece()} do
        %Piece{} = right_rotated_piece = rotate_n(piece, &Notris.rotate_right/1, n)
        %Piece{} = left_rotated_piece = rotate_n(piece, &Notris.rotate_left/1, 4 - n)

        right_rotated_piece.points == left_rotated_piece.points
      end
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

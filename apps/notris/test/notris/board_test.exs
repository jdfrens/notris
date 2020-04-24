defmodule Notris.BoardTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Notris.{Board, Bottom, Location, Piece}
  alias Notris.PropertyTestGenerators, as: G

  describe "add/2" do
    test "add an S to a board" do
      {:ok, piece} = Piece.new(:s, 0, :red)
      {:ok, board} = Board.new({10, 10})
      board_with_s_piece = Board.add_to_bottom(board, piece, Location.new(2, 3))

      assert board_with_s_piece.bottom == %{
               Location.new(3, 5) => :red,
               Location.new(4, 4) => :red,
               Location.new(4, 5) => :red,
               Location.new(5, 4) => :red
             }
    end

    property "number of locations on bottom of board must be leq to 4 times the number of pieces" do
      check all board <- G.empty_board(),
                zipped_location_pieces <-
                  list_of({G.location(board.width, board.height), G.piece()}) do
        new_board =
          Enum.reduce(zipped_location_pieces, board, fn
            {%Location{} = location, %Piece{} = piece}, board ->
              Board.add_to_bottom(board, piece, location)
          end)

        assert Enum.count(new_board.bottom) <= 4 * length(zipped_location_pieces)
      end
    end
  end

  describe "#start_location" do
    property "row always -4" do
      check all board <- G.board() do
        assert %Location{row: -4} = Board.start_location(board)
      end
    end

    property "col always between 1 and width" do
      check all board <- G.board() do
        assert %Location{col: col} = Board.start_location(board)
        assert col in 1..board.width
      end
    end
  end

  describe "#collides?" do
    property "no collides inside boundaries" do
      check all board <- G.empty_board(),
                location <- G.location(board.width, board.height) do
        refute Board.collides?(board, location)
      end
    end

    property "collides off the left of the grid" do
      check all board <- G.empty_board(),
                {col_offset, row} <- {positive_integer(), G.row_in(board)} do
        assert Board.collides?(board, Location.new(1 - col_offset, row))
      end
    end

    property "collides off the right of the grid" do
      check all board <- G.empty_board(),
                {col_offset, row} <- {positive_integer(), G.row_in(board)} do
        assert Board.collides?(board, Location.new(board.width + col_offset, row))
      end
    end

    property "does NOT collide off the top of the grid" do
      check all board <- G.empty_board(),
                {col, row} <- {G.col_in(board), positive_integer()} do
        refute(Board.collides?(board, Location.new(col, -1 * row)))
      end
    end

    property "collides off the bottom of the grid" do
      check all board <- G.empty_board(),
                {col, row_offset} <- {G.col_in(board), positive_integer()} do
        assert Board.collides?(board, Location.new(col, board.height + row_offset))
      end
    end

    property "collides with dropped pieces" do
      check all board <- G.board() do
        assert Enum.all?(Bottom.locations_of(board.bottom), fn p -> Board.collides?(board, p) end)
      end
    end

    property "misses dropped pieces" do
      check all board <- G.board(),
                location <- G.location(board.width, board.height),
                location not in Bottom.locations_of(board.bottom) do
        refute Board.collides?(board, location)
      end
    end
  end
end

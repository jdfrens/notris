defmodule Notris.BoardTest do
  use ExUnit.Case, async: true
  use PropCheck

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
      forall board <- G.empty_board() do
        forall zipped_location_pieces <- list({G.location(board.width, board.height), G.piece()}) do
          new_board =
            Enum.reduce(zipped_location_pieces, board, fn
              {%Location{} = location, %Piece{} = piece}, board ->
                Board.add_to_bottom(board, piece, location)
            end)

          Enum.count(new_board.bottom) <= 4 * length(zipped_location_pieces)
        end
      end
    end
  end

  describe "#collides?" do
    property "no collides inside boundaries" do
      forall board <- G.empty_board() do
        forall location <- G.location(board.width, board.height) do
          not Board.collides?(board, location)
        end
      end
    end

    property "collides off the left of the grid" do
      forall board <- G.empty_board() do
        forall {col_offset, row} <- {pos_integer(), G.row_in(board)} do
          Board.collides?(board, Location.new(1 - col_offset, row))
        end
      end
    end

    property "collides off the right of the grid" do
      forall board <- G.empty_board() do
        forall {col_offset, row} <- {pos_integer(), G.row_in(board)} do
          Board.collides?(board, Location.new(board.width + col_offset, row))
        end
      end
    end

    property "collides off the top of the grid" do
      forall board <- G.empty_board() do
        forall {col, row_offset} <- {G.col_in(board), pos_integer()} do
          Board.collides?(board, Location.new(col, 1 - row_offset))
        end
      end
    end

    property "collides off the bottom of the grid" do
      forall board <- G.empty_board() do
        forall {col, row_offset} <- {G.col_in(board), pos_integer()} do
          Board.collides?(board, Location.new(col, board.height + row_offset))
        end
      end
    end

    property "collides with dropped pieces" do
      forall board <- G.board() do
        Enum.all?(Bottom.locations_of(board.bottom), fn p -> Board.collides?(board, p) end)
      end
    end

    property "misses dropped pieces" do
      forall board <- G.board() do
        unoccupied_location =
          such_that location <- G.location(board.width, board.height),
                    when: location not in Bottom.locations_of(board.bottom)

        forall location <- unoccupied_location do
          not Board.collides?(board, location)
        end
      end
    end
  end
end

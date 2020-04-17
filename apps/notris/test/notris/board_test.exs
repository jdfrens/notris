defmodule Notris.BoardTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias Notris.{Board, Piece}
  alias Notris.PropertyTestGenerators, as: G

  describe "add/2" do
    test "add an S to a board" do
      {:ok, piece} = Piece.new(:s, 0, :red)
      {:ok, board} = Board.new({10, 10})
      board_with_s_piece = Board.add(board, {2, 3}, piece)

      assert board_with_s_piece.points == %{
               {3, 5} => :red,
               {4, 4} => :red,
               {4, 5} => :red,
               {5, 4} => :red
             }
    end

    property "number of points on board must be leq to 4 times the number of pieces" do
      forall board <- G.empty_board() do
        forall zipped_location_pieces <- list({G.location(board.width, board.height), G.piece()}) do
          new_board =
            Enum.reduce(zipped_location_pieces, board, fn {location, piece}, board ->
              Board.add(board, location, piece)
            end)

          Enum.count(new_board.points) <= 4 * length(zipped_location_pieces)
        end
      end
    end
  end

  describe "#collides?" do
    property "no collides inside boundaries" do
      forall board <- G.empty_board() do
        forall {col, row} <- {G.col_in(board), G.row_in(board)} do
          not Board.collides?(board, {col, row})
        end
      end
    end

    property "collides off the left of the grid" do
      forall board <- G.empty_board() do
        forall {col_offset, row} <- {pos_integer(), G.row_in(board)} do
          Board.collides?(board, {1 - col_offset, row})
        end
      end
    end

    property "collides off the right of the grid" do
      forall board <- G.empty_board() do
        forall {col_offset, row} <- {pos_integer(), G.row_in(board)} do
          Board.collides?(board, {board.width + col_offset, row})
        end
      end
    end

    property "collides off the top of the grid" do
      forall board <- G.empty_board() do
        forall {col, row_offset} <- {G.col_in(board), pos_integer()} do
          Board.collides?(board, {col, 1 - row_offset})
        end
      end
    end

    property "collides off the bottom of the grid" do
      forall board <- G.empty_board() do
        forall {col, row_offset} <- {G.col_in(board), pos_integer()} do
          Board.collides?(board, {col, board.height + row_offset})
        end
      end
    end

    property "collides with dropped pieces" do
      forall board <- G.board() do
        Enum.all?(board.points, fn p -> Board.collides?(board, p) end)
      end
    end

    property "misses dropped pieces" do
      forall board <- G.board() do
        empty_point =
          such_that p <- G.location(board.width, board.height), when: p not in board.points

        forall point <- empty_point do
          not Board.collides?(board, point)
        end
      end
    end
  end
end

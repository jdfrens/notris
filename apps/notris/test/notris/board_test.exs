defmodule Notris.BoardTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias Notris.Board
  alias Notris.PropertyTestGenerators, as: G

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

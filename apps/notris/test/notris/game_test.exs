defmodule Notris.GameTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias Notris.{Board, Game, Piece}

  # important limits when placing and moving an O shape
  @width_of_o 2
  @height_of_o 2

  describe "#maybe_move_left" do
    property "moves left until it hits the left border" do
      {:ok, board} = Board.new({10, 10})
      {:ok, piece} = Piece.new(:o, 0, :red)

      last_col = board.width - @width_of_o
      last_row = board.height - @height_of_o

      forall {col, row} = location <- {choose(1, last_col), choose(1, last_row)} do
        original_game = board |> Game.new() |> Game.add(piece, location)

        games =
          Stream.iterate(original_game, fn game ->
            Game.maybe_move_left(game)
          end)

        num_moved = col + 1
        moved = games |> Enum.take(num_moved)
        last_moved = moved |> List.last()
        first_unmoved = games |> Stream.drop(num_moved) |> Enum.take(1) |> List.first()

        (Enum.map(moved, fn g -> g.location |> elem(0) end) == Enum.to_list(col..0))
        |> Kernel.and(last_moved.location == {0, row})
        |> Kernel.and(first_unmoved.location == {0, row})
      end
    end
  end
end

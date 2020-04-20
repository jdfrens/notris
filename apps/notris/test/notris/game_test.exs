defmodule Notris.GameTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias Notris.{Board, Game, Location, Piece}
  alias Notris.PropertyTestGenerators, as: G

  # important limits when placing and moving an O shape
  @width_of_o 2

  describe "maybe_move_left/1" do
    property "moves left until it hits the left border" do
      {:ok, board} = Board.new({10, 10})
      {:ok, piece} = Piece.new(:o, 0, :red)

      forall location <- G.location_for(piece, board.width, board.height) do
        original_game = board |> Game.new() |> Game.add(piece, location)

        games =
          Stream.iterate(original_game, fn game ->
            Game.maybe_move_left(game)
          end)

        num_moved = location.col + 1
        moved = games |> Enum.take(num_moved)
        last_moved = moved |> List.last()
        first_unmoved = games |> Stream.drop(num_moved) |> Enum.take(1) |> List.first()

        last_location = Location.new(0, location.row)

        (Enum.map(moved, fn g -> g.location.col end) == Enum.to_list(location.col..0))
        |> Kernel.and(last_moved.location == last_location)
        |> Kernel.and(first_unmoved.location == last_location)
      end
    end
  end

  describe "maybe_move_right/1" do
    property "moves right until it hits the right border" do
      {:ok, board} = Board.new({10, 10})
      {:ok, piece} = Piece.new(:o, 0, :red)

      forall location <- G.location_for(piece, board.width, board.height) do
        original_game = board |> Game.new() |> Game.add(piece, location)

        games =
          Stream.iterate(original_game, fn game ->
            Game.maybe_move_right(game)
          end)

        num_moved = board.width - location.col + 1 - @width_of_o
        moved = games |> Enum.take(num_moved)
        last_moved = moved |> List.last()
        first_unmoved = games |> Stream.drop(num_moved) |> Enum.take(1) |> List.first()

        last_location = Location.new(board.width - @width_of_o, location.row)

        (Enum.map(moved, fn g -> g.location.col end) ==
           Enum.to_list(location.col..(board.width - 2)))
        |> Kernel.and(last_moved.location == last_location)
        |> Kernel.and(first_unmoved.location == last_location)
      end
    end
  end

  describe "maybe_move_down/1" do
    property "moves down until it hits the bottom" do
      {:ok, empty_board} = Board.new({10, 10})
      # fill two rows at the bottom
      board = G.fill_bottom(empty_board, 2)

      {:ok, piece} = Piece.new(:o, 0, :red)

      forall col <- choose(1, 10 - @width_of_o) do
        # start off the board
        location = Location.new(col, -2)
        original_game = board |> Game.new() |> Game.add(piece, location)

        games =
          Stream.iterate(original_game, fn game ->
            Game.maybe_move_down(game)
          end)

        interesting_steps =
          games
          |> Enum.take(10)

        Enum.map(interesting_steps, & &1.location) ==
          [
            Location.new(col, -2),
            Location.new(col, -1),
            Location.new(col, 0),
            Location.new(col, 1),
            Location.new(col, 2),
            Location.new(col, 3),
            Location.new(col, 4),
            Location.new(col, 5),
            Location.new(col, 6),
            nil
          ]
      end
    end
  end
end

defmodule Notris.GameTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Notris.{Board, Game, Location, Piece}
  alias Notris.PropertyTestGenerators, as: G

  # important limits when placing and moving an O shape
  @width_of_o 2

  describe "new/0,3" do
    property "set the board, piece, and location (without error checking)" do
      {:ok, piece} = Piece.new(:o, 0, :red)

      check all board <- G.board(),
                location <- G.location_for(piece, board.width, board.height) do
        assert Game.new(board, piece, location) == %Game{
                 board: board,
                 piece: piece,
                 location: location,
                 game_over: false
               }
      end
    end

    property "set the piece and location if not specified" do
      check all board <- G.board() do
        game = Game.new(board)

        assert %Piece{} = game.piece
        assert %Location{col: col, row: row} = game.location
        assert col in 0..board.width
        assert row < 0
      end
    end
  end

  describe "maybe_move_left/1" do
    property "moves left until it hits the left border" do
      {:ok, board} = Board.new({10, 10})
      {:ok, piece} = Piece.new(:o, 0, :red)

      check all location <- G.location_for(piece, board.width, board.height) do
        original_game = Game.new(board, piece, location)

        games =
          Stream.iterate(original_game, fn game ->
            Game.maybe_move_left(game)
          end)

        num_moved = location.col + 1
        moved = games |> Enum.take(num_moved)
        last_moved = moved |> List.last()
        first_unmoved = games |> Stream.drop(num_moved) |> Enum.take(1) |> List.first()

        last_location = Location.new(0, location.row)

        assert Enum.map(moved, fn g -> g.location.col end) == Enum.to_list(location.col..0)
        assert last_moved.location == last_location
        assert first_unmoved.location == last_location
        assert Enum.all?(moved, fn g -> not g.game_over end)
      end
    end
  end

  describe "maybe_move_right/1" do
    property "moves right until it hits the right border" do
      {:ok, board} = Board.new({10, 10})
      {:ok, piece} = Piece.new(:o, 0, :red)

      check all location <- G.location_for(piece, board.width, board.height) do
        original_game = Game.new(board, piece, location)

        games =
          Stream.iterate(original_game, fn game ->
            Game.maybe_move_right(game)
          end)

        num_moved = board.width - location.col + 1 - @width_of_o
        moved = games |> Enum.take(num_moved)
        last_moved = moved |> List.last()
        first_unmoved = games |> Stream.drop(num_moved) |> Enum.take(1) |> List.first()

        last_location = Location.new(board.width - @width_of_o, location.row)

        assert Enum.map(moved, fn g -> g.location.col end) ==
                 Enum.to_list(location.col..(board.width - 2))

        assert last_moved.location == last_location
        assert first_unmoved.location == last_location
        assert Enum.all?(moved, fn g -> not g.game_over end)
      end
    end
  end

  describe "maybe_move_down/1" do
    property "moves down until it hits the bottom" do
      {:ok, empty_board} = Board.new({10, 10})
      # fill two rows at the bottom
      board = G.fill_bottom(empty_board, 2)

      {:ok, piece} = Piece.new(:o, 0, :red)

      check all col <- integer(1..(10 - @width_of_o)) do
        # start off the board
        location = Location.new(col, -2)
        original_game = Game.new(board, piece, location)

        games =
          Stream.iterate(original_game, fn game ->
            Game.maybe_move_down(game)
          end)

        interesting_games =
          games
          |> Enum.take(10)

        assert Enum.map(interesting_games, & &1.location) ==
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
                   # new piece at top of board
                   Location.new(5, -4)
                 ]

        assert List.first(interesting_games).piece == piece
        assert List.last(interesting_games).piece != piece

        assert Enum.all?(interesting_games, fn g -> not g.game_over end)
      end
    end

    property "game over if piece cannot drop and is above the top" do
      {:ok, empty_board} = Board.new({10, 3})
      # fill two rows at the bottom, leaving one empty
      board = G.fill_bottom(empty_board, 2)

      {:ok, piece} = Piece.new(:o, 0, :red)

      check all col <- integer(1..(10 - @width_of_o)) do
        # start off the board
        location = Location.new(col, -2)

        game0 = Game.new(board, piece, location)
        game1 = Game.maybe_move_down(game0)
        game2 = Game.maybe_move_down(game1)

        refute game0.game_over
        refute game1.game_over
        assert game2.game_over
      end
    end
  end
end

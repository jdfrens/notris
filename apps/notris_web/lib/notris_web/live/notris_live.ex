defmodule NotrisWeb.NotrisLive do
  @moduledoc """
  LiveView to play the game of Notris.
  """

  use Phoenix.LiveView

  alias NotrisWeb.NotrisLive.{WebColor, XML}
  alias Phoenix.LiveView.Socket

  @type coords :: {non_neg_integer(), non_neg_integer()}
  @type dimension :: non_neg_integer()
  @type colors :: {WebColor.hexcode(), WebColor.hexcode()}

  @box_width 30
  @border_width 2
  @board_color "#18FE22"

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket |> new_game() |> schedule_tick()}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~L"""
    <div phx-window-keydown="keydown">
      <?xml version="1.0" encoding="iso-8859-1"?>
      <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 496 496" style="enable-background:new 0 0 496 496;" xml:space="preserve">
        <%= render_border(@game) %>
        <%= render_piece(@game) %>
        <%= render_bottom(Notris.bottom_of(@game)) %>
      </svg>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("keydown", %{"key" => key}, socket) do
    {:noreply, move(socket, key)}
  end

  defp move(socket, "ArrowLeft") do
    update(socket, :game, fn game -> Notris.maybe_move_left(game) end)
  end

  defp move(socket, "ArrowRight") do
    update(socket, :game, fn game -> Notris.maybe_move_right(game) end)
  end

  defp move(socket, _key) do
    socket
  end

  @spec new_game(Socket.t()) :: Socket.t()
  def new_game(socket) do
    {:ok, game} = Notris.new_game({10, 10})

    moved_game =
      game
      |> Notris.maybe_move_down()
      |> Notris.maybe_move_down()
      |> Notris.maybe_move_down()
      |> Notris.maybe_move_down()

    socket
    |> assign(%{game: moved_game})
  end

  @spec schedule_tick(Socket.t()) :: Socket.t()
  def schedule_tick(socket) do
    socket
  end

  def render_piece(game) do
    game
    |> Notris.piece_as_bottom()
    |> render_bottom()
  end

  @spec render_bottom(Notris.bottom()) :: list(String.t())
  def render_bottom(bottom) do
    bottom
    |> convert_colors()
    |> convert_coordinates()
    |> to_boxes()
    |> Enum.map(&XML.render(&1))
  end

  def render_border(game) do
    view_width = 2 * @border_width + game.board.width * @box_width
    view_height = 2 * @border_width + game.board.height * @box_width
    XML.border({view_width, view_height}, @board_color) |> XML.render()
  end

  defp convert_colors(stream) do
    Stream.map(stream, fn {location, color} ->
      {location, WebColor.hexcodes_of(color)}
    end)
  end

  defp convert_coordinates(stream) do
    Stream.map(stream, fn {location, hexcodes} ->
      {{@border_width + (location.col - 1) * @box_width,
        @border_width + (location.row - 1) * @box_width}, hexcodes}
    end)
  end

  defp to_boxes(stream) do
    Stream.map(stream, fn {{x, y}, hexcodes} ->
      XML.box({x, y}, @box_width, hexcodes)
    end)
  end
end

defmodule NotrisWeb.PageController do
  use NotrisWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

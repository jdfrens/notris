defmodule NotrisWeb.Router do
  use NotrisWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NotrisWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/notris", NotrisLive
  end
end

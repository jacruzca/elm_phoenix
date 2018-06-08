defmodule ElmPhoenixWeb.Router do
  use ElmPhoenixWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # scope "/", ElmPhoenixWeb do
  #   # Use the default browser stack
  #   pipe_through(:browser)

  #   get("/", PageController, :index)
  # end

  # Other scopes may use custom stacks.
  scope "/api/v1", ElmPhoenixWeb do
    pipe_through(:api)

    get("/users", UserController, :index)
    post("/signup", UserController, :signup)
    post("/signin", UserController, :signin)
  end
end

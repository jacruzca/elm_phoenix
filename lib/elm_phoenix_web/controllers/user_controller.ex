defmodule ElmPhoenixWeb.UserController do
  use ElmPhoenixWeb, :controller

  alias ElmPhoenix.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end
end

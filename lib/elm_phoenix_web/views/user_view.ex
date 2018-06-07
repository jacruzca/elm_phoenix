defmodule ElmPhoenixWeb.UserView do
  use ElmPhoenixWeb, :view

  alias ElmPhoenixWeb.UserView

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, email: user.email}
  end
end

defmodule ElmPhoenixWeb.UserView do
  use ElmPhoenixWeb, :view

  alias ElmPhoenixWeb.UserView

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, email: user.email}
  end

  def render("signedup.json", %{token: token, user: user}) do
    %{token: token, user: render_one(user, UserView, "user.json")}
  end

  def render("signedin.json", %{token: token, user: user}) do
    %{token: token, user: render_one(user, UserView, "user.json")}
  end

  def render("409.json", %{changeset: changeset}) do
    %{status: "Conflict", errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end

  def render("401.json", %{message: message}) do
    %{
      status: "Unauthorized",
      errors: message
    }
  end
end

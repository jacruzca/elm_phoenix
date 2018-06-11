defmodule ElmPhoenixWeb.UserController do
  use ElmPhoenixWeb, :controller

  alias ElmPhoenix.Accounts
  alias ElmPhoenix.Accounts.User
  alias ElmPhoenix.Guardian

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def signup(conn, user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn |> render("signedup.json", token: token, user: user)
    else
      {:error, changeset} ->
        conn
        |> put_status(:conflict)
        |> render("409.json", changeset: changeset)
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.get_user_by_email(email),
         {:ok, _verified_user} <- Accounts.check_password(user, password),
         {:ok, token, _claims} = Guardian.encode_and_sign(user) do
      conn |> render("signedin.json", token: token, user: user)
    else
      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> render("401.json", message: message)
    end
  end
end

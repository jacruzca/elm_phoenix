defmodule ElmPhoenix.Accounts do
  import Ecto.Query, warn: false
  import Comeonin.Bcrypt

  alias ElmPhoenix.Repo
  alias ElmPhoenix.Accounts.User
  alias ElmPhoenix.Guardian

  def list_users do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by_email(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def check_password(user, password) when is_binary(password) do
    Comeonin.Bcrypt.check_pass(user, password)
  end

  def new_user do
    User.changeset(%User{}, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end

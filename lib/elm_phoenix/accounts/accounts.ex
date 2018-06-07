defmodule ElmPhoenix.Accounts do
  import Ecto.Query, warn: false

  alias ElmPhoenix.Repo
  alias ElmPhoenix.Accounts.User

  def list_users do
    Repo.all(User)
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

defmodule ElmPhoenix.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElmPhoenix.Accounts.User

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:password_confirmation, :string, virtual: true)
    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_confirmation])
    |> validate_required([:name, :email])
    # Check that email is valid
    |> validate_format(:email, ~r/@/)
    # Check that password length is >= 8
    |> validate_length(:password, min: 8)
    # Check that password === password_confirmation
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
  end
end

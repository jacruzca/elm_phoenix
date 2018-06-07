defmodule ElmPhoenix.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElmPhoenix.Accounts.User

  @required_fields [:name, :email, :password, :password_confirmation]
  @optional_fields []

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:encrypted_password, :string)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields, @optional_fields)
    # Check that password === password_confirmation
    |> validate_confirmation(:password, message: "password doesn't match")
    # Check that email is valid
    |> validate_format(:email, ~r/@/)
    # Check that password length is >= 8
    |> validate_length(:password, min: 8)
    |> encrypt_password()
    |> validate_required([:name, :email, :encrypted_password])
    |> unique_constraint(:email)
  end

  defp encrypt_password(changeset) do
    with password when not is_nil(password) <- get_change(changeset, :password) do
      put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
    else
      _ -> changeset
    end
  end
end

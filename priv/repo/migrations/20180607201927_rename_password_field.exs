defmodule ElmPhoenix.Repo.Migrations.RenamePasswordField do
  use Ecto.Migration

  def change do
    rename(table(:users), :password, to: :encrypted_password)
  end
end

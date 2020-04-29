defmodule BankApiPhx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstName, :string
      add :lastName, :string
      add :email, :string
      add :password, :string
      add :phone, :string
      add :acl, :string, default: "user"

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end

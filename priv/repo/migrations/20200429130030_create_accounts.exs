defmodule BankApiPhx.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :decimal, precision: 10, scale: 2
      add :user_id, references(:users, on_delete: :delete_all, type: :id)

      timestamps()
    end

  end
end

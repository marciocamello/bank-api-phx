defmodule BankApiPhx.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:balance]}

  schema "accounts" do
    field :balance, :decimal, default: 1000
    belongs_to(:user, BankApiPhx.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
  end
end

defmodule BankApiPhx.Operations.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :account_from, :string
    field :account_to, :string
    field :type, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:value, :account_from, :account_to, :type])
    |> validate_required([:value, :account_from, :account_to, :type])
  end
end

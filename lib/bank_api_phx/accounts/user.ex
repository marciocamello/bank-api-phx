defmodule BankApiPhx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :firstName, :lastName, :email, :phone, :accounts, :acl]}

  schema "users" do
    field :acl, :string, default: "user"
    field :email, :string
    field :firstName, :string
    field :lastName, :string
    field :password, :string
    field :phone, :string
    has_one(:accounts, BankApiPhx.Accounts.Account)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstName, :lastName, :email, :password, :phone, :acl])
    |> validate_required([:firstName, :lastName, :email, :password, :phone, :acl])
    |> validate_format(:email, ~r/^[A-Za-z0-9\._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/)
    |> unique_constraint([:email])
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  @doc """
    Encrypt password
  """
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end

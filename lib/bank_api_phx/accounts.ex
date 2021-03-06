defmodule BankApiPhx.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BankApiPhx.Repo

  alias BankApiPhx.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
    |> Repo.preload(:accounts)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(accounts: [:user])
  end


  @doc """
    Bind account to user

  # Examples
      iex> alias BankApi.Models.Users
      iex> user = Users.get_user(id)
      iex> account = Users.bind_account(user)
      %BankApi.Schemas.Account{}
  """
  def bind_account(user) do
    Ecto.build_assoc(user, :accounts)
    |> Repo.insert!()
  end


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
    Get user from email

  # Examples
      iex> alias BankApi.Models.Users
      iex> Users.get_by_email(
        "email@email.com"
      )
      { :ok, %BankApi.Schemas.User{} }
  """
  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}

      user ->
        user =
          user
          |> Repo.preload(accounts: [:user])

        {:ok, user}
    end
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias BankApiPhx.Accounts.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
    Get user from email

  # Examples
      iex> alias BankApi.Models.Users
      iex> Users.get_by_email(
        "email@email.com"
      )
      { :ok, %BankApi.Schemas.User{} }
  """
  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}

      user ->
        user =
          user
          |> Repo.preload(accounts: [:user])

        {:ok, user}
    end
  end


  @doc """
    Update current account balance

  # Examples
      iex> alias BankApi.Models.Accounts
  """
  def update_balance(%Account{} = account, attrs, apply \\ false) do
    case apply do
      true ->
        account
        |> Account.changeset(attrs)
        |> Repo.update()

      false ->
        account =
          account
          |> Account.changeset(attrs)

        {
          :info,
          %{
            email: account.data.user.email,
            old_balance: account.data.balance,
            new_balance: account.changes.balance
          }
        }
    end
  end

  @doc """
    Update transfer operation to user account

  # Examples
      iex> alias BankApi.Models.Accounts
  """
  def update_balance(%Account{} = from, %Account{} = to, from_attrs, to_attrs, apply \\ false) do
    case apply do
      true ->
        from
        |> Account.changeset(from_attrs)
        |> Repo.update()

        to
        |> Account.changeset(to_attrs)
        |> Repo.update()

      false ->
        from =
          from
          |> Account.changeset(from_attrs)

        to =
          to
          |> Account.changeset(to_attrs)

        {
          :info,
          %{
            from: %{
              email: from.data.user.email,
              old_balance: from.data.balance,
              new_balance: from.changes.balance
            },
            to: %{
              email: to.data.user.email,
              old_balance: to.data.balance,
              new_balance: to.changes.balance
            }
          }
        }
    end
  end
end

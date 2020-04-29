defmodule BankApiPhx.Operations do
  @moduledoc """
  The Operations context.
  """

  import Ecto.Query, warn: false
  alias BankApiPhx.Repo

  alias BankApiPhx.Operations.Transaction
  alias BankApiPhx.Accounts
  alias BankApiPhxWeb.Auth.Guardian

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions(query \\ Transaction) do
    Repo.all(query)
  end

  @doc """
    List all transactions and total

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> %{"filter" => filter,"type" => type,"period" => period} = %{"filter" => "","type" => "","period" => ""}
      iex> filter_transactions(filter, type, period)
      %{
        "total" => #Decimal<0.00>,
        "transactions" => [%BankApi.Schemas.Transaction{}]
      }
  """
  def filter_transactions(filter, type, period) do
    query =
      filter_period(filter, period, type)
      |> list_transactions

    filtered_params(query)
  end

  @doc false
  defp filter_period(filter, period, type) do
    %{"year" => year, "month" => month, "day" => day} = get_period(filter, period)
    %{"start_date" => start_date, "end_date" => end_date} = get_dates(filter, year, month, day)

    filtered_query(type, start_date, end_date)
  end

  @doc false
  defp get_period(filter, period) do
    year = DateTime.utc_now().year
    month = DateTime.utc_now().month
    day = DateTime.utc_now().month

    case filter do
      "daily" ->
        %{"year" => year, "month" => month, "day" => String.to_integer(period)}

      "monthly" ->
        %{"year" => year, "month" => String.to_integer(period), "day" => 01}

      "yearly" ->
        %{"year" => String.to_integer(period), "month" => month, "day" => 01}

      _ ->
        %{"year" => year, "month" => month, "day" => day}
    end
  end

  @doc false
  defp get_dates(filter, year, month, day) do
    start_date = NaiveDateTime.from_erl!({{year, month, day}, {00, 00, 00}})

    case filter do
      "daily" ->
        end_date = NaiveDateTime.from_erl!({{year, month, day}, {23, 59, 59}})
        %{"end_date" => end_date, "start_date" => start_date}

      _ ->
        days_in_month = Date.days_in_month(start_date)
        end_date = NaiveDateTime.from_erl!({{year, month, days_in_month}, {00, 00, 00}})
        %{"end_date" => end_date, "start_date" => start_date}
    end
  end

  @doc false
  defp filtered_params(transactions) do
    total = get_total_transactions(transactions)
    %{"transactions" => transactions, "total" => total}
  end

  @doc false
  defp filtered_query(type, start_date, end_date) do
    case type do
      "" ->
        from(t in Transaction, where: t.inserted_at >= ^start_date and t.inserted_at <= ^end_date)

      _ ->
        from(t in Transaction,
          where: t.inserted_at >= ^start_date and t.inserted_at <= ^end_date and t.type == ^type
        )
    end
  end

  @doc """
    Create transaction

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> Transactions.create_transaction(
        %{
          "value" => 10.00,
          "account_from" => "from@email.com",
          "account_to" => "to@email.com"
        }
      )
      { :ok, %BankApi.Schemas.Transaction{} }
  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Get total transactions with list

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> Transactions.get_total_transactions([])
      iex> transaction = Transactions.get_total_transactions([
        %BankApi.Schemas.Transaction{
          account_from: "1@gmail.com",
          account_to: "1@gmail.com",
          id: 5,
          inserted_at: ~N[2020-04-22 02:21:49],
          type: "withdrawal",
          updated_at: ~N[2020-04-22 02:21:49],
          value: "10.00"
        }
      ])
      #Decimal<10.00>
  """
  def get_total_transactions(transactions) do
    Enum.map(transactions, fn tr -> Map.get(tr, :value) end)
    |> Enum.reduce(0, fn h, total -> Decimal.add(total, h) end)
  end

  @doc """
    Withdrawal money from user account

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> params = %{"account" => "teste@email.com", "value" => 100.00}
      iex> Transactions.withdrawal(params)
      {:ok, %BankApi.Schemas.Account{}}
  """
  def withdrawal(params) do
    %{
      "user" => user,
      "value" => value,
      "password_confirm" => password_confirm
    } = params

    # check value is less then 0.00
    with {:ok, value} <- check_value(value) do
      # udate balance from accounts and a request value
      case update_balance(user.accounts.balance, value) do
        {:ok, new_balance} ->
          # check password confirmation before finish operation
          case password_confirmation(user, password_confirm) do
            {:error, :unauthorized} ->
              {:error, :unauthorized}

            {:info, :wait_confirmation} ->
              {:info, _account} =
                Accounts.update_balance(
                  user.accounts,
                  %{"balance" => new_balance}
                )

            {:ok, :confirmed} ->
              # create transaction
              create_transaction(%{
                "value" => value,
                "account_from" => user.email,
                "account_to" => user.email,
                "type" => "withdrawal"
              })

              {:ok, account} =
                Accounts.update_balance(
                  user.accounts,
                  %{"balance" => new_balance},
                  true
                )
          end

        {:error, :not_funds} ->
          {:error, :not_funds}
      end
    end
  end

  @doc """
    Transfer money from user
    account to other user account

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> alias BankApi.Models.Users
      iex> params = %{"account" => "teste@email.com", "value" => 100.00}
      iex> {:ok, user} = Users.get_by_email(account)
      iex> params = conn.body_params
        |> Map.put("user", user)
      iex> Transactions.transfer(params)
      {:ok, %BankApi.Schemas.Account{}}
  """
  def transfer(params) do
    %{
      "user" => user,
      "account_to" => account_to,
      "value" => value,
      "password_confirm" => password_confirm
    } = params

    # check value is less then 0.00
    with {:ok, value} <- check_value(value) do
      # check account to transfer by email
      with {:ok, account_to} <- Accounts.get_by_email(account_to) do
        # udate balance from accounts and a request value and to request
        case update_balance(user.accounts.balance, account_to.accounts.balance, value) do
          {:ok, new_balance} ->
            # get balance from sender and balance from receiver accounts
            %{"new_from_balance" => new_from_balance, "new_to_balance" => new_to_balance} =
              new_balance

            # check password confirmation before finish operation
            case password_confirmation(user, password_confirm) do
              {:error, :unauthorized} ->
                {:error, :unauthorized}

              {:info, :wait_confirmation} ->
                {:info, _account} =
                  Accounts.update_balance(
                    user.accounts,
                    account_to.accounts,
                    %{"balance" => new_from_balance},
                    %{"balance" => new_to_balance}
                  )

              {:ok, :confirmed} ->
                # create transaction
                create_transaction(%{
                  "value" => value,
                  "account_from" => user.email,
                  "account_to" => account_to.email,
                  "type" => "transfer"
                })

                {:ok, account} =
                  Accounts.update_balance(
                    user.accounts,
                    account_to.accounts,
                    %{"balance" => new_from_balance},
                    %{"balance" => new_to_balance},
                    true
                  )
            end

          {:error, :not_funds} ->
            {:error, :not_funds}
        end
      end
    end
  end

  @doc false
  defp check_value(value) do
    value = String.to_float(value)
    case Decimal.equal?(Decimal.from_float(value), 0) do
      true ->
        {:error, :zero_value}

      false ->
        {:ok, value}
    end
  end

  @doc false
  defp password_confirmation(user, password_confirm \\ false) do
    if password_confirm do
      case Guardian.validate_password(password_confirm, user.password) do
        true ->
          {:ok, :confirmed}

        false ->
          {:error, :unauthorized}
      end
    else
      {:info, :wait_confirmation}
    end
  end

  @doc false
  defp update_balance(balance, value) do
    new_balance = sub_balance(balance, value)

    case Decimal.negative?(new_balance) do
      true ->
        {:error, :not_funds}

      false ->
        {:ok, new_balance}
    end
  end

  @doc false
  defp update_balance(from_balance, to_balance, value) do
    new_from_balance = sub_balance(from_balance, value)
    new_to_balance = add_balance(to_balance, value)

    case Decimal.negative?(new_from_balance) do
      true ->
        {:error, :not_funds}

      false ->
        {:ok,
          %{
            "new_from_balance" => new_from_balance,
            "new_to_balance" => new_to_balance
          }}
    end
  end

  @doc false
  defp add_balance(balance, value) do
    balance
    |> Decimal.add(Decimal.from_float(value))
  end

  @doc false
  defp sub_balance(balance, value) do
    balance
    |> Decimal.sub(Decimal.from_float(value))
  end
end

defmodule BankApiPhxWeb.AccountController do
  use BankApiPhxWeb, :controller

  alias BankApiPhx.Accounts
  alias BankApiPhx.Accounts.User
  alias BankApiPhxWeb.Auth.Guardian
  alias BankApiPhx.Operations

  action_fallback BankApiPhxWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = account} <- Accounts.create_user(user_params) do
      Accounts.bind_account(account)
      account = Accounts.get_user!(account.id)
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, account))
      |> render("show.json", account: account)
    end
  end

  def index(conn, %{}) do
    account = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", account: account)
  end

  def withdrawal(conn, params) do
    case Guardian.Plug.current_resource(conn) do
      account ->
        params =
          params
          |> Map.put("user", account)

        case Operations.withdrawal(params) do
          {:error, :zero_value} ->
            render(conn, "errors.json", errors: "Value cannot be less than 0.00")

          {:error, :unauthorized} ->
            render(conn, "errors.json", errors: "Invalid credentials")

          {:error, :not_funds} ->
            render(conn, "errors.json", errors: "You don't have enough funds")

          {:info, _account} ->
            render(
              conn,
              "withdrawal.json",
              data: %{
                message: "Please check your transaction",
                result: _account
              }
            )

          {:ok, _result} ->
            render(
              conn,
              "withdrawal.json",
              data: %{
                message: "Successful withdrawal!",
                result: %{
                  "email" => _result.user.email,
                  "new_balance" => _result.balance
                }
              }
            )
        end

      {:error, _reason} ->
        render(conn, "errors.json", errors: "Unauthorized")
    end
  end

  def transfer(conn, params) do
    case Guardian.Plug.current_resource(conn) do
      account ->
        params =
          params
          |> Map.put("user", account)

        case Operations.transfer(params) do
          {:error, :zero_value} ->
            render(conn, "errors.json", errors: "Value cannot be less than 0.00")

          {:error, :unauthorized} ->
            render(conn, "errors.json", errors: "Invalid credentials")

          {:error, :not_funds} ->
            render(conn, "errors.json", errors: "You don't have enough funds")

          {:info, _account} ->
            render(
              conn,
              "transfer.json",
              data: %{
                message: "Please check your transaction",
                result: _account
              }
            )

          {:ok, _result} ->
            render(
              conn,
              "transfer.json",
              data: %{
                message: "Successful withdrawal!",
                result: %{
                  "email" => _result.user.email,
                  "new_balance" => _result.balance
                }
              }
            )
        end

      {:error, _reason} ->
        render(conn, "errors.json", errors: "Unauthorized")
    end
  end

  def terminate(conn, %{}) do
    account = Guardian.Plug.current_resource(conn)

    with {:ok, %User{}} <- Accounts.delete_user(account) do
      render(
        conn,
        "terminate.json",
        message: %{
          "message" => "You accounts has been finished"
        }
      )
    end
  end
end

defmodule BankApiPhxWeb.AccountController do
  use BankApiPhxWeb, :controller

  alias BankApiPhx.Accounts
  alias BankApiPhx.Accounts.User

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
    account = Accounts.get_user!(2)
    render(conn, "show.json", account: account)
  end

  def withdrawal(conn, params) do
    render(conn, "withdrawal.json", data: params)
  end

  def transfer(conn, params) do
    render(conn, "transfer.json", data: params)
  end

  def terminate(conn, %{}) do
    account = Accounts.get_user!(2)

    with {:ok, %User{}} <- Accounts.delete_user(account) do
      render(conn, "terminate.json", message: %{
        "message" => "You accounts has been finished"
      })
    end
  end
end

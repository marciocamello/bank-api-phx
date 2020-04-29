defmodule BankApiPhxWeb.AuthController do
  use BankApiPhxWeb, :controller

  alias BankApiPhx.Accounts
  alias BankApiPhx.Accounts.User

  action_fallback BankApiPhxWeb.FallbackController

  def login(conn, params) do
    render(conn, "login.json", data: params)
  end
end

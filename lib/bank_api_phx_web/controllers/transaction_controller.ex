defmodule BankApiPhxWeb.TransactionController do
  use BankApiPhxWeb, :controller

  alias BankApiPhx.Operations
  alias BankApiPhx.Operations.Transaction
  alias BankApiPhxWeb.Auth.Guardian

  action_fallback BankApiPhxWeb.FallbackController

  def report(conn, params) do
    account = Guardian.Plug.current_resource(conn)
    if Guardian.is_admin(account.acl) do

      %{
        "filter" => filter,
        "type" => type,
        "period" => period
      } = params

      result = Operations.filter_transactions(filter, type, period)

      filter =
        if filter == "" do
          "All"
        else
          String.capitalize(filter)
        end

      transactions = Operations.list_transactions()
      render(conn, "index.json", message: filter <> " transactions", result: result)
    else
      render(conn, "errors.json", errors: "Unauthorized")
    end
  end
end

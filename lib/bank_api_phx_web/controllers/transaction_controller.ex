defmodule BankApiPhxWeb.TransactionController do
  use BankApiPhxWeb, :controller

  alias BankApiPhx.Operations
  alias BankApiPhx.Operations.Transaction

  action_fallback BankApiPhxWeb.FallbackController

  def report(conn, _params) do
    transactions = Operations.list_transactions()
    render(conn, "index.json", transactions: transactions)
  end
end

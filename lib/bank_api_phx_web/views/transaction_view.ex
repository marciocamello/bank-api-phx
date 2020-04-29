defmodule BankApiPhxWeb.TransactionView do
  use BankApiPhxWeb, :view
  alias BankApiPhxWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      value: transaction.value,
      account_from: transaction.account_from,
      account_to: transaction.account_to,
      type: transaction.type}
  end
end

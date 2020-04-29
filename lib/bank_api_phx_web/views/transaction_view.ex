defmodule BankApiPhxWeb.TransactionView do
  use BankApiPhxWeb, :view
  alias BankApiPhxWeb.TransactionView

  def render("index.json", %{message: message, result: result}) do
    %{
      message: message,
      result: result
    }
  end

  def render("errors.json", %{errors: errors}) do
    %{errors: errors}
  end
end

defmodule BankApiPhxWeb.AccountView do
  use BankApiPhxWeb, :view
  alias BankApiPhxWeb.AccountView

  def render("transfer.json", %{data: data}) do
    %{data: data}
  end

  def render("withdrawal.json", %{data: data}) do
    %{data: data}
  end

  def render("terminate.json", %{data: data}) do
    %{data: data}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      firstName: account.firstName,
      lastName: account.lastName,
      email: account.email,
      phone: account.phone,
      accounts: account.accounts,
    }
  end

  def render("errors.json", %{errors: errors}) do
    %{errors: errors}
  end
end

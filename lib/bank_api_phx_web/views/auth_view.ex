defmodule BankApiPhxWeb.AuthView do
  use BankApiPhxWeb, :view

  def render("login.json", %{data: data}) do
    %{data: data}
  end
end

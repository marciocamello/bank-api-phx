defmodule BankApiPhxWeb.PageView do
  use BankApiPhxWeb, :view
  alias BankApiPhxWeb.PageView

  def render("index.json", %{message: message}) do
    %{message: message}
  end

end

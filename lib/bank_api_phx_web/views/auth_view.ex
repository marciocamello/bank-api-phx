defmodule BankApiPhxWeb.AuthView do
  use BankApiPhxWeb, :view

  def render("login.json", %{message: message, user: user, token: token}) do
    %{
      message: message,
      user: user,
      token: token,
    }
  end

  def render("errors.json", %{errors: errors}) do
    %{errors: errors}
  end
end

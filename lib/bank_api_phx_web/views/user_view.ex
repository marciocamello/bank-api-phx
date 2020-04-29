defmodule BankApiPhxWeb.UserView do
  use BankApiPhxWeb, :view
  alias BankApiPhxWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: user.phone,
      acl: user.acl,
      accounts: user.accounts
    }
  end
end

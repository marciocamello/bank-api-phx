defmodule BankApiPhxWeb.PageController do
  use BankApiPhxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json", message: "BankAPI V1 - Check docs to how to use")
  end
end

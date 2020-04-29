defmodule BankApiPhxWeb.AuthController do
  use BankApiPhxWeb, :controller

  alias BankApiPhxWeb.Auth.Guardian

  action_fallback BankApiPhxWeb.FallbackController

  def login(conn, params) do
    %{"email" => email, "password" => password} = params

    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        render(conn, "login.json", message: "Login success!", user: user, token: token)

      {:error, :unauthorized} ->
        render(conn, "errors.json", errors: "Unauthorized")

      {:error, :not_found} ->
        render(conn, "errors.json", errors: "Invalid credentials")
    end
  end
end

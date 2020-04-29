defmodule BankApiPhxWeb.Auth.ErrorHandler do
  @moduledoc """
    Guardian error handling
  """
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @doc """
    Return default error with code 401 an Unauthorized message
  """
  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    send_resp(conn, 401, Jason.encode!(%{message: "Unauthorized"}))
  end
end

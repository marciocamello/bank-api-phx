defmodule BankApiPhxWeb.Auth.Pipeline do
  @moduledoc """
    Guardian pipelino to set multiple settings to plug.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :bank_api_phx,
    module: BankApiPhxWeb.Auth.Guardian,
    error_handler: BankApiPhxWeb.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.VerifyCookie)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, ensure: true)
end

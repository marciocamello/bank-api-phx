defmodule BankApiPhx.Repo do
  use Ecto.Repo,
    otp_app: :bank_api_phx,
    adapter: Ecto.Adapters.Postgres
end

defmodule BankApiPhx.Repo do
  use Ecto.Repo,
      otp_app: :bank_api_phx,
      adapter: Ecto.Adapters.Postgres

  if Mix.env() in [:dev, :test] do
    @spec truncate(Ecto.Schema.t()) :: :ok
    def truncate(schema) do
      table_name = schema.__schema__(:source)
      query("TRUNCATE #{table_name} CASCADE", [])
      :ok
    end
  end
end

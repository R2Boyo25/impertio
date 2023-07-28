defmodule Impertio.Repo do
  use Ecto.Repo,
    otp_app: :impertio,
    adapter: Ecto.Adapters.Postgres
end

defmodule Schwabble.Repo do
  use Ecto.Repo,
    otp_app: :schwabble,
    adapter: Ecto.Adapters.Postgres
end

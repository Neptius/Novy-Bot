defmodule NovyBot.Repo do
  use Ecto.Repo,
    otp_app: :novy_bot,
    adapter: Ecto.Adapters.Postgres
end

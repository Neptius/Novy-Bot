defmodule NovyBot.Cache do
  use Nebulex.Cache,
    otp_app: :novy_bot,
    adapter: Nebulex.Adapters.Local
end

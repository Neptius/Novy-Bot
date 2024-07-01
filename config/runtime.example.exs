import Config

config :novy_bot,
  guild_ids: [
    # One or more server ids, comma separated
    # Leave empty to register commands globally
    # Globally registered commands can take up to an hour to appear in a server
  ],
  stratz_token: ""

# Ensure you've set an environment variable called DISCORD_TOKEN with the discord api token you want to use
config :nostrum, token: ""

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :info

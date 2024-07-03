import Config

config :floki, :html_parser, Floki.HTMLParser.Html5ever

config :novy_bot,
  ecto_repos: [NovyBot.Repo]

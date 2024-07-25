defmodule NovyBot.Commands.FFXIV.Wol do
  require Logger

  # alias NovyBot.Api.FFXIV.FFlog.Wol
  alias NovyBot.Api.FFXIV.Tomestone.Wol

  def name(), do: "wol"

  def description(), do: "Résumé de votre personnage."

  def type(), do: :slash

  def options(), do: [
    %{
      type: :integer,
      name: "lodestone_id",
      description: "[TEMP] ID Lodestone de votre personnage.",
      required: true
    }
  ]

  def execute(interaction) do
    [%{name: "lodestone_id", value: lodestone_id}] = interaction.data.options

    case Wol.call(lodestone_id) do
      {:ok, data} ->
        IO.inspect(data)
        [
          embeds: [
            %{
              title: "Neptius Lumireis",
              url: "https://www.fflogs.com/character/id/12673432",
              description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi.",
              fields: [
                %{
                  name: "Classe",
                  value: "Samouraï",
                  inline: true
                },
                %{
                  name: "Niveau",
                  value: "80",
                  inline: true
                },
                %{
                  name: "Rang",
                  value: "1",
                  inline: true
                },
                %{
                  name: "Classe",
                  value: "Samouraï",
                  inline: true
                },
                %{
                  name: "Niveau",
                  value: "80",
                  inline: true
                },
                %{
                  name: "Rang",
                  value: "1",
                  inline: true
                },
                %{
                  name: "Classe",
                  value: "Samouraï",
                  inline: false
                },
                %{
                  name: "Niveau",
                  value: "80",
                  inline: true
                },
                %{
                  name: "Rang",
                  value: "1",
                  inline: true
                },
                %{
                  name: "Rang",
                  value: "1",
                  inline: true
                }
              ],
              footer: %{
                text: "FFLogs",
                icon_url: "https://i.ibb.co/kcZc5KC/fflogs-logo.png",
              },
              timestamp: DateTime.to_iso8601(DateTime.utc_now()),
            }
          ]
        ]

      {:error, message} ->
        IO.inspect(message)
        [
          content: message
        ]
    end
  end
end

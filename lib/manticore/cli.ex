defmodule Manticore.CLI do
  def main(argv) do
    {opts, _, _} =
      OptionParser.parse(argv,
        strict: [prey: :string, fangs: :integer, venom: :string, store: :string]
      )

    Manticore.Sense.process(opts)
  end
end

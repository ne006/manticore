defmodule Manticore.Sense do
  alias Manticore.Core
  alias Manticore.Request

  def process(opts) do
    prey = Keyword.get(opts, :prey, nil)
    fangs = Keyword.get(opts, :fangs, 1)
    venom = Keyword.get(opts, :venom, nil)
    store = Keyword.get(opts, :store, nil)

    unless store, do: raise("Store is not specified")

    payload =
      if prey && File.exists?(prey) do
        Jason.decode!(File.read!(prey))
      else
        raise "Prey-file #{prey} does not exist"
      end

    requests =
      payload["requests"]
      |> Enum.map(fn req ->
        %Request{
          method: (req["method"] || "get") |> String.to_atom(),
          url: req["url"],
          headers: (req["headers"] || %{}) |> Map.to_list(),
          body: req["body"] || ""
        }
      end)

    result = Core.run(requests, fangs)

    result =
      Map.get_and_update(
        result,
        :responses,
        fn responses ->
          {
            responses,
            responses
            |> Enum.map(fn response ->
              Map.get_and_update(
                response,
                :headers,
                &{&1, Enum.into(&1, %{})}
              )
              |> elem(1)
            end)
          }
        end
      )
      |> elem(1)

    File.write(store, Jason.encode_to_iodata!(result))
  end
end

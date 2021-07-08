defmodule Manticore.Sting do
  alias Manticore.Request

  def execute(args \\ []) do
    args |> Keyword.get(:requests, []) |> Enum.map(fn req -> Request.execute(req) end)
  end
end

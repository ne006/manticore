defmodule Manticore.Core do
  alias Manticore.Sting
  alias Manticore.Prey

  def run(requests, fangs) do
    responses =
      (fn reqs ->
         chunk_size =
           cond do
             rem(Enum.count(reqs), fangs) > 0 -> div(Enum.count(reqs), fangs)
             true -> div(Enum.count(reqs), fangs) + 1
           end

         Enum.chunk_every(reqs, chunk_size)
       end).(requests)
      |> Enum.map(fn reqs -> Sting.execute(requests: reqs) end)
      |> Enum.concat()

    report = Prey.digest(responses)

    %{
      report: report,
      responses: responses |> Enum.map(&Map.from_struct(&1))
    }
  end
end

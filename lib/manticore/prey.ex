defmodule Manticore.Prey do
  def digest(requests \\ []) do
    sorted_requests =
      %{
        success: fn req -> Enum.member?(200..299, req.status_code) end,
        neutral: fn req ->
          Enum.member?(300..399, req.status_code) || Enum.member?(100..199, req.status_code)
        end,
        error: fn req -> Enum.member?(400..599, req.status_code) || req.status_code == -1 end,
        total: fn req -> req end
      }
      |> Map.new(fn {key, filter} -> {key, Enum.filter(requests, filter)} end)

    count_requests = sorted_requests |> Map.new(fn {key, reqs} -> {key, Enum.count(reqs)} end)

    %{
      count: count_requests,
      share:
        sorted_requests
        |> Map.new(fn {key, reqs} ->
          case count_requests[:total] do
            0 -> {key, 0.0}
            _ -> {key, Enum.count(reqs) / count_requests[:total]}
          end
        end),
      execution_time:
        sorted_requests
        |> Map.new(fn {key, reqs} ->
          case count_requests[key] do
            0 ->
              {key, %{min: 0.0, max: 0.0, avg: 0.0}}

            _ ->
              {key,
               %{
                 min: Enum.min_by(reqs, fn req -> req.execution_time end).execution_time,
                 max: Enum.max_by(reqs, fn req -> req.execution_time end).execution_time,
                 avg:
                   Enum.reduce(reqs, 0.0, fn req, acc -> acc + req.execution_time end) /
                     count_requests[key]
               }}
          end
        end)
    }
  end
end

defmodule Manticore.StingTest do
  use ExUnit.Case

  alias Manticore.Request
  alias Manticore.Sting

  import Mox

  setup_all do
    Mox.defmock(Manticore.Request, for: Manticore.Request)

    :ok
  end

  setup do
    requests = %{
      %Request{url: "https://www.google.com"} => %{
        url: "https://www.google.com",
        status_code: 200,
        body: "",
        execution_time: 49
      },
      %Request{url: "https://api.github.com/users/ne006"} => %{
        url: "https://api.github.com/users/ne006",
        status_code: 200,
        body: "",
        execution_time: 49
      }
    }

    {
      :ok,
      requests: requests,
      request_mock: fn
        request ->
          case requests[request] do
            nil -> Map.merge(request, %{status_code: -1, error: "Mock match error"})
            response -> Map.merge(request, response)
          end
      end
    }
  end

  test "execute/1", %{requests: requests, request_mock: request_mock} do
    expect(Manticore.Request, :execute, 2, request_mock)

    result = Sting.execute(requests: Map.keys(requests))
    responses = Map.values(requests)

    Enum.with_index(result)
    |> Enum.each(fn tuple ->
      {real_response, index} = tuple

      assert MapSet.subset?(
               responses |> Enum.at(index) |> MapSet.new(),
               MapSet.new(real_response |> Map.from_struct())
             )
    end)
  end

  test "start_link/1", %{requests: requests, request_mock: request_mock} do
    expect(Manticore.Request, :execute, 2, request_mock)

    task = Task.async(Sting, :execute, [[requests: Map.keys(requests)]])

    result = Task.await(task)
    responses = Map.values(requests)

    Enum.with_index(result)
    |> Enum.each(fn tuple ->
      {real_response, index} = tuple

      assert MapSet.subset?(
               responses |> Enum.at(index) |> MapSet.new(),
               MapSet.new(real_response |> Map.from_struct())
             )
    end)
  end
end

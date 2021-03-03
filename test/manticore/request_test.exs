defmodule Manticore.RequestTest do
  use ExUnit.Case

  alias Manticore.Request

  import Mox

  setup_all do
    Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)
    :ok
  end

  setup do
    {
      :ok,
      requests: %{
        google: %Request{url: "https://www.google.com"},
        github_profile: %Request{url: "https://api.github.com/users/ne006"}
      },
      responses: %{
        google: %{status_code: 200},
        github_profile: %{
          status_code: 200,
          body: ""
        }
      }
    }
  end

  test "execute/1 for google", %{
    requests: %{google: request},
    responses: %{google: response}
  } do
    %{url: url, body: body, headers: headers} = request

    expect(HTTPoison.BaseMock, :request, fn
      :get, ^url, ^body, ^headers -> {:ok, response}
      _method, _url, _body, _headers -> {:error, 'Mock error'}
    end)

    real_response = Request.execute(request)

    assert MapSet.subset?(
             MapSet.new(response),
             real_response |> Map.from_struct() |> MapSet.new()
           )

    assert(Map.has_key?(real_response, :execution_time))
  end

  test "execute/1 for github_profile", %{
    requests: %{github_profile: request},
    responses: %{github_profile: response}
  } do
    %{url: url, body: body, headers: headers} = request

    expect(HTTPoison.BaseMock, :request, fn
      :get, ^url, ^body, ^headers -> {:ok, response}
      _method, _url, _body, _headers -> {:error, 'Mock error'}
    end)

    real_response = Request.execute(request)

    assert MapSet.subset?(
             MapSet.new(response),
             real_response |> Map.from_struct() |> MapSet.new()
           )

    assert(Map.has_key?(real_response, :execution_time))
  end
end

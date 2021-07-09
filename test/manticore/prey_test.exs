defmodule Manticore.PreyTest do
  use ExUnit.Case

  alias Manticore.Prey

  setup do
    {
      :ok,
      requests: [
        %{
          url: "https://www.google.com",
          status_code: 200,
          body: "",
          execution_time: 49
        },
        %{
          url: "https://api.github.com/users/ne006",
          status_code: 200,
          body: "",
          execution_time: 34
        },
        %{
          url: "http://wsj.com",
          status_code: 302,
          body: "",
          execution_time: 80
        },
        %{
          url: "https://lenta.ru/jdkjadlkjsdald",
          status_code: 400,
          body: "",
          execution_time: 5
        },
        %{
          url: "https://localhost:9898",
          status_code: -1,
          body: "",
          execution_time: 0
        }
      ]
    }
  end

  test "digest/1", %{requests: requests} do
    report = Prey.digest(requests)

    assert(
      report[:share] == %{
        success: 0.4,
        neutral: 0.2,
        error: 0.4,
        total: 1.0
      }
    )

    assert(
      report[:count] == %{
        success: 2,
        neutral: 1,
        error: 2,
        total: 5
      }
    )

    assert(
      report[:execution_time] == %{
        success: %{min: 34, max: 49, avg: 41.5},
        neutral: %{min: 80, max: 80, avg: 80},
        error: %{min: 0, max: 5, avg: 2.5},
        total: %{min: 0, max: 80, avg: 33.6}
      }
    )
  end
end

defmodule Manticore.Request do
  defstruct method: :get, url: nil, headers: [], body: ""

  @type t :: %__MODULE__{
          method: atom() | nil,
          url: binary(),
          headers: list() | nil,
          body: binary() | nil
        }

  @spec execute(__MODULE__.t()) :: map()
  @callback execute(__MODULE__.t()) :: map()

  def execute(%__MODULE__{} = request) do
    start = :os.system_time(:milli_seconds)

    {status_code, error} =
      case HTTPoison.request(
             request.method,
             request.url,
             request.body,
             request.headers,
             ssl: [verify: :verify_none]
           ) do
        {:ok, response} ->
          {response.status_code, nil}

        {:error, error} ->
          {-1, error.reason}
      end

    execution_time = :os.system_time(:milli_seconds) - start

    Map.merge(
      request,
      %{
        status_code: status_code,
        error: error,
        execution_time: execution_time
      }
    )
  end
end
